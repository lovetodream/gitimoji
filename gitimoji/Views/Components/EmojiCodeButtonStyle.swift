//
//  EmojiCodeButtonStyle.swift
//  gitimoji
//
//  Created by Timo Zacherl on 21.09.20.
//

import SwiftUI

struct EmojiCodeButtonStyle: ButtonStyle {
    var hovering: Bool
    var border: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(hovering ? Color.secondary.opacity(0.2) : Color.clear)
            .cornerRadius(5.0)
    }
}
