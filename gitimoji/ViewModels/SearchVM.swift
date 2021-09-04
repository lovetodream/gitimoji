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
    @Published var autoLaunchEnabled: Bool = false {
        didSet {
            toggleAutoLaunch(bool: autoLaunchEnabled)
        }
    }
    @Published var isLoading: Bool = false
    @Published var fetchState: FetchState = .stateless
    @Published var searchText: String = "" {
        didSet {
            updateSearchText(width: searchText)
        }
    }
    
    var allGitmojis = [Gitmoji]()
    let managedObjectContext = PersistenceController.shared.container.viewContext
    let fetchRequest: NSFetchRequest<Gitmoji> = Gitmoji.fetchRequest()
    var helperBundleName = "com.timozacherl.GitimojiAutoLaunchHelper"
    
    init() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            self.allGitmojis = try managedObjectContext.fetch(fetchRequest)
            self.searchResults = self.allGitmojis
            
            if self.allGitmojis.count == 0 {
                refetchGitmojis()
            }
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
            } catch let error as NSError {
                print(error)
            }
            
            do {
                let fetchRequest = NSFetchRequest<Gitmoji>(entityName: "Gitmoji")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                self.allGitmojis = try self.managedObjectContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    self.searchText = ""
                }
            } catch let error as NSError {
                print(error)
                DispatchQueue.main.async {
                    self.fetchState = .error
                }
            }
            
            DispatchQueue.main.async {
                self.fetchState = .success
            }
        }
    }
}

enum FetchState {
    case loading, success, error, stateless
}
