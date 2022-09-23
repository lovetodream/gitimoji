//
//  AppDelegate.swift
//  GitimojiAutoLaunchHelper
//
//  Created by Timo Zacherl on 21.09.20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == "com.timozacherl.gitimoji"
        }

        if !isRunning {
            var url = Bundle.main.bundleURL
            print(url)
            for _ in 1...4 {
                url = url.deletingLastPathComponent()
            }
            let configuration = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.openApplication(at: url, configuration: .init())
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

