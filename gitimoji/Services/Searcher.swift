//
//  Searcher.swift
//  gitimoji
//
//  Created by Timo Zacherl on 23.09.22.
//

import Foundation

struct Searcher {
    static func getResults<T: Collection>(forText text: String, on gitmojis: T) -> [Gitmoji] where T.Element: Gitmoji {
        return gitmojis.filter { emoji in
            let searchMatcher = SmartSearchMatcher(searchString: text.lowercased())

            guard var code = emoji.code, let emojiDescription = emoji.emojiDescription else {
                return false
            }

            let matchesCode = searchMatcher.matches(code.lowercased())
            let matchesDescription = searchMatcher.matches(emojiDescription.lowercased())
            code.removeFirst()
            code.removeLast()
            let matchesCodeWithoutDoubleDots = searchMatcher.matches(code.lowercased())
            // Maybe put this if let in the first statement
            let matchesEmoji: Bool
            if let emoji = emoji.emoji {
                matchesEmoji = searchMatcher.matches(emoji)
            } else {
                matchesEmoji = false
            }

            return matchesDescription || matchesCode || matchesCodeWithoutDoubleDots || matchesEmoji
        }
    }
}
