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
    
    @Published var searchResults = [Gitmoji]()
    @Published var autoLaunchEnabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var isFetching: Bool = false
    
    var allGitmojis = [Gitmoji]()
    let managedObjectContext = PersistenceController.shared.container.viewContext
    let fetchRequest: NSFetchRequest<Gitmoji> = Gitmoji.fetchRequest()
    var helperBundleName = "com.timozacherl.GitmojiAutoLaunchHelper"
    
    init() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        
        do {
            self.allGitmojis = try managedObjectContext.fetch(fetchRequest)
            
            if self.allGitmojis.count == 0 {
                let _ = refetchGitmojis()
            }
            
            self.searchResults = self.allGitmojis
        } catch let error as NSError {
            print("Could not fetch gitmojis. \(error), \(error.userInfo)")
        }
        
        autoLaunchEnabled = foundHelper
    }
    
    public func toggleAutoLaunch(bool: Bool) {
        SMLoginItemSetEnabled(helperBundleName as CFString, bool)
    }
    
    public func updateSearchText(width text: String) {
        self.isLoading = true
        
        if text.count > 0 {
            getSearchResults(forText: text)
        } else {
            self.searchResults = allGitmojis
        }
        
        self.isLoading = false
    }
    
    public func getSearchResults(forText text: String) {
        self.searchResults = allGitmojis.filter { $0.description.lowercased().contains(text) }
    }
    
    public func refetchGitmojis() -> Bool {
        isFetching = true
        
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
            } catch let error as NSError {
                print(error)
            }
        }
        
        do {
            self.allGitmojis = try self.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
            return false
        }
        
        isFetching = false
        return true
    }
}
