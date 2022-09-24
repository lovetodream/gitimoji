//
//  AppDelegate.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import Cocoa
import SwiftUI
import KeyboardShortcuts

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    var settingsWindow: NSWindow!

    let persistence = PersistenceController.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        let popover = NSPopover()
        
        popover.contentSize = NSSize(width: 370, height: 330)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView.environment(\.managedObjectContext, persistence.container.viewContext))
        
        self.popover = popover
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        KeyboardShortcuts.onKeyUp(for: .toggleApp) { [self] in
            togglePopover(self)
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.makeKey()
            }
        }
    }

    @objc func openPreferencesWindow() {
        if settingsWindow == nil {
            let settingsView = SettingsView()
            settingsWindow =  NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false)
            settingsWindow.isReleasedWhenClosed = false
            settingsWindow.center()
            settingsWindow.title = "Gitimoji Settings"
            settingsWindow.setFrameAutosaveName("Settings")
            settingsWindow.contentView = NSHostingView(rootView: settingsView.environment(\.managedObjectContext, persistence.container.viewContext))
        }
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow.makeKeyAndOrderFront(nil)
    }

}

