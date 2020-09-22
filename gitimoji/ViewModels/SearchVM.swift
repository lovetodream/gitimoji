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
    
    @Published var searchResults: [Gitmoji] = Gitmojis().emojis
    @Published var autoLaunchEnabled: Bool = false
    @Published var isLoading: Bool = false
    
    var helperBundleName = "com.timozacherl.GitmojiAutoLaunchHelper"
    
    init() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
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
            self.searchResults = Gitmojis().emojis
        }
        
        self.isLoading = false
    }
    
    public func getSearchResults(forText text: String) {
        self.searchResults = Gitmojis().emojis.filter { $0.description.lowercased().contains(text) }
    }
}
