//
//  GMSearchField.swift
//  gitimoji
//
//  Created by Timo Zacherl on 23.09.22.
//

import SwiftUI

struct GMSearchField: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        .init(self)
    }

    @Binding var searchText: String

    func makeNSView(context: Context) -> NSSearchField {
        let view = NSSearchField()
        view.delegate = context.coordinator
        return view
    }

    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = searchText
    }

    class Coordinator: NSObject, NSSearchFieldDelegate {
        var parent: GMSearchField

        init(_ parent: GMSearchField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textView = obj.object as? NSTextField else  {
                return
            }
            self.parent.searchText = textView.stringValue
        }
    }

}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

