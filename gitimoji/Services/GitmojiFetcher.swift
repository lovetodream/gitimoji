//
//  GitmojiFetcher.swift
//  gitimoji
//
//  Created by Timo Zacherl on 23.09.22.
//

import CoreData

@MainActor
class GitmojiFetcher: ObservableObject {
    @Published private(set) var state: FetchState = .stateless

    func refetch(on viewContext: NSManagedObjectContext) async {
        state = .loading

        remove(from: viewContext)

        guard let gitmojis = try? await Networking.fetchEmojis() else {
            return
        }

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
