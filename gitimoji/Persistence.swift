//
//  Persistence.swift
//  gitimoji
//
//  Created by Timo Zacherl on 13.06.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Gitmoji(context: viewContext)
            newItem.emoji = "🎨"
            newItem.emojiEntity = "&#x1f3a8;"
            newItem.code = ":art:"
            newItem.name = "art"
            newItem.emojiDescription = "Improve structure / format of the code."
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError). \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "gitimoji")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
