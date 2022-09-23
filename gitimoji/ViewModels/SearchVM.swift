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
    
    init() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == Constants.helperBundleName
        }
        autoLaunchEnabled = foundHelper
    }
    
    public func toggleAutoLaunch(bool: Bool) {
        SMLoginItemSetEnabled(Constants.helperBundleName as CFString, bool)
    }
}
