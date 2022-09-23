//
//  SearchVM.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import Foundation
import SwiftUI
import ServiceManagement

class SearchVM: ObservableObject {

    @Published var autoLaunchEnabled: Bool = false {
        didSet {
            toggleAutoLaunch(bool: autoLaunchEnabled)
        }
    }
    @Published var fetchState: FetchState = .stateless

    let managedObjectContext = PersistenceController.shared.container.viewContext

    var helperBundleName = "com.timozacherl.GitimojiAutoLaunchHelper"
    
    init() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        autoLaunchEnabled = foundHelper
    }
    
    public func toggleAutoLaunch(bool: Bool) {
        SMLoginItemSetEnabled(helperBundleName as CFString, bool)
    }
    
    private func removeGitmojis() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gitmoji")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    public func refetchGitmojis() {
        self.fetchState = .loading
        
        self.removeGitmojis()
        
        fetchEmojis { gitmojis in
            gitmojis.forEach { gitmoji in
                let newEntity = Gitmoji(context: self.managedObjectContext)
                newEntity.name = gitmoji.name
                newEntity.emojiDescription = gitmoji.description
                newEntity.emojiEntity = gitmoji.entity
                newEntity.code = gitmoji.code
                newEntity.emoji = gitmoji.emoji
                newEntity.semver = gitmoji.semver?.rawValue
            }
            do {
                try self.managedObjectContext.save()

                DispatchQueue.main.async {
                    self.fetchState = .success
                }
            } catch let error as NSError {
                print(error)

                DispatchQueue.main.async {
                    self.fetchState = .error
                }
            }
        }
    }
}
