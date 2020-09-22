//
//  Defaults.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import Foundation

struct Defaults {
    private static let userDefault = UserDefaults.standard
    
    static func saveSettings(copyEmojiValue: Bool) {
        userDefault.set(copyEmojiValue, forKey: "copyEmoji")
    }
    
    static func getSettings() -> Bool {
        return userDefault.value(forKey: "copyEmoji") as? Bool ?? false
    }
}
