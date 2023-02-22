//
//  GitmojiFetcher.swift
//  gitimoji
//
//  Created by Timo Zacherl on 23.09.22.
//

import CoreData

enum FetchError: LocalizedError {
    case failedToSave(reason: String?)
    case failedToFetch(reason: String?)

    var errorDescription: String? {
        switch self {
        case .failedToSave(let reason):
            return reason ?? "Failed to save Gitmojis to local disk due to an unknown error."
        case .failedToFetch(let reason):
            return reason ?? "Failed to fetch Gitmojis from the provided fetch URL. Please check the URL and try again."
        }
    }
}

@MainActor
class GitmojiFetcher: ObservableObject {
    @Published private(set) var state: FetchState = .stateless
    @Published var lastError: FetchError?
    @Published var isShowingError = false

    func refetch(on viewContext: NSManagedObjectContext) async {
        state = .loading

        remove(from: viewContext)

        do {
            let gitmojis = try await Networking.fetchEmojis()

            gitmojis.forEach { gitmoji in
                let newEntity = Gitmoji(context: viewContext)
                newEntity.name = gitmoji.name
                newEntity.emojiDescription = gitmoji.description
                newEntity.emojiEntity = gitmoji.entity
                newEntity.code = gitmoji.code
                newEntity.emoji = gitmoji.emoji
                newEntity.semver = gitmoji.semver?.rawValue
            }

            do {
                try viewContext.save()
                state = .success
            } catch {
                state = .error
                lastError = .failedToSave(reason: error.localizedDescription)
                isShowingError = true
            }
        } catch {
            state = .error
            lastError = .failedToFetch(reason: error.localizedDescription)
            isShowingError = true
        }
    }

    private func remove(from viewContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gitmoji")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.executeAndMergeChanges(using: deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
