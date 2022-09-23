//
//  ContentView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Gitmoji.name, ascending: true)])
    private var gitmojis: FetchedResults<Gitmoji>

    @State private var searchText = ""

    private var searchResults: [Gitmoji] {
        if searchText.count > 0 {
            return Searcher.getResults(forText: searchText, on: gitmojis)
        }
        return Array(gitmojis)
    }

    @State private var showSettings = false
    @State private var showAbout = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GMSearchField(searchText: $searchText)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(searchResults) { gitmoji in
                        EmojiRow(gitmoji: gitmoji)
                    }
                }
                .padding(.top, 9)
            }
            Divider()
            HStack {
                Button("Settings") {
                    NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from: nil)
                }
                Spacer()
                Button("Quit Gitimoji") {
                    NSApplication.shared.terminate(self)
                }
            }
            .padding(.top, 9)
        }
        .buttonStyle(.plain)
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
