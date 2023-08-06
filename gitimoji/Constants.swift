//
//  Constants.swift
//  gitimoji
//
//  Created by Timo Zacherl on 21.02.21.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleApp = Self("toggleApp")
}

enum Constants {
    static let helperBundleIdentifier = "com.timozacherl.GitimojiAutoLaunchHelper"

    enum DefaultKey: String {
        case gitmojiFetchURL
        case copyEmoji
        case closePopoverAfterCopy
    }

    enum Link {
        static let repository: URL = {
            guard let url = URL(string: "https://github.com/lovetodream/gitimoji") else {
                preconditionFailure("Repository URL invalid")
            }
            return url
        }()

        static let gitmoji: URL = {
            guard let url = URL(string: "https://gitmoji.dev/") else {
                preconditionFailure("Gitmoji URL invalid")
            }
            return url
        }()
    }
}
