//
//  Pasteboard.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import Foundation
import AppKit

func copyToPasteboard(text: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(text, forType: NSPasteboard.PasteboardType.string)
}
