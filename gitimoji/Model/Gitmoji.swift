//
//  Gitmoji.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import Foundation

struct Gitmoji: Decodable, Identifiable, Equatable {
    var id: UUID
    var emoji: String
    var entity: String
    var code: String
    var description: String
    var name: String
    var background: String
    
    #if DEBUG
    static let exampleGitmoji = Gitmoji(id: UUID(), emoji: "🎨", entity: "&#x1f3a8;", code: ":art:", description: "Improve structure / format of the code.", name: "art", background: "ff7280")
    #endif
}

class Gitmojis: ObservableObject {
    @Published var emojis = Bundle.main.decode([Gitmoji].self, from: "gitmojis.json")
}
