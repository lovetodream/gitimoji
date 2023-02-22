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

    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText = ""

    private var searchResults: [Gitmoji] {
        if searchText.count > 0 {
            return Searcher.getResults(forText: searchText, on: gitmojis)
        }
        return Array(gitmojis)
    }

    @State private var showSettings = false
    @State private var showAbout = false

    @StateObject private var fetcher = GitmojiFetcher()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GMSearchField(searchText: $searchText)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if searchResults.isEmpty {
                        HStack {
                            Spacer()
                            if searchText.isEmpty {
                                Text("No Gitmojis downloaded, please open Settings to perform the initial Download.")
                            } else {
                                Text("No matching Gitmojis found")
                            }
                            Spacer()
                        }
                        .padding()
                        .multilineTextAlignment(.center)
                    } else {
                        ForEach(searchResults) { gitmoji in
                            EmojiRow(gitmoji: gitmoji)
                        }
                    }
                }
                .padding(.vertical, 9)
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
        .task {
            if gitmojis.isEmpty {
                await fetcher.refetch(on: viewContext)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
