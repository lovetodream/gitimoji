//
//  EmojiCodeButtonStyle.swift
//  gitimoji
//
//  Created by Timo Zacherl on 21.09.20.
//

import SwiftUI

struct EmojiCodeButtonStyle: ButtonStyle {
    var hovering: Bool
    var background: Color
    var border: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(5)
            .background(hovering ? background : Color(white: 0, opacity: 0))
            .cornerRadius(5.0)
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
            .animation(.easeIn(duration: 0.1))
                    .animation(.spring())
    }
}
