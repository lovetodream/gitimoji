//
//  EmojiRow.swift
//  gitimoji
//
//  Created by Timo Zacherl on 21.09.20.
//

import SwiftUI

struct EmojiRow: View {
    var gitmoji: Gitmoji
    
    @State private var hovering = false
    @State private var recentlyCopied = false
    @Binding var copyEmoji: Bool
    
    var body: some View {
        Button(action: {
            // copy to clipboard
            self.triggerRecentlyCopied()
        }, label: {
            HStack {
                Group {
                    Text(gitmoji.emoji ?? "🥗").font(.custom("Apple Color Emoji", size: 20)).padding(.vertical, -4)
                    Text(gitmoji.emojiDescription ?? "standard description").padding(.vertical, 2)
                }
                Spacer()
                if recentlyCopied {
                    Text("Copied").padding(.horizontal, 8).padding(.vertical, 2).background(Color(hex: "00e676")).cornerRadius(5.0)
                }
            }
        }).buttonStyle(EmojiCodeButtonStyle(hovering: self.hovering, background: Color(hex: "00e676", opacity: 0.4), border: Color(hex: "00e676")))
        .onHover { hovering in
            self.hovering = hovering
        }
    }
    
    func triggerRecentlyCopied() {
        copyToPasteboard(text: copyEmoji ? gitmoji.emoji ?? "🥗" : gitmoji.code ?? ":salad:")
        recentlyCopied = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.recentlyCopied = false
        }
    }
}

struct EmojiRow_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRow(gitmoji: Gitmoji(), copyEmoji: .constant(false))
    }
}
