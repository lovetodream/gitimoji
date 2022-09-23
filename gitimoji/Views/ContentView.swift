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

    @StateObject private var vm = SearchVM()

    @State private var showSettings: Bool = false
    @State private var showAbout = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ZStack {
                        Color(NSColor.controlBackgroundColor).frame(height: 22).cornerRadius(6)
                        
                        HStack {
                            Text("🔍")
                                .padding(.leading, 5)
                            
                            TextField("Search...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image("DismissIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.gray)
                                        .frame(width: 16, height: 16)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.trailing, 5)
                            }
                        }
                    }
                    
                    Button {
                        vm.fetchState = .stateless
                        showSettings.toggle()
                    } label: {
                        Image("SettingsIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }.padding(.bottom, 10)
                if showSettings {
                    SettingsView(vm: vm, showSettings: $showSettings, showAbout: $showAbout)
                }
                ScrollView {
                    ForEach(searchResults) { gitmoji in
                        EmojiRow(gitmoji: gitmoji)
                    }
                }
            }
            .padding(.horizontal).padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Divider()
                Button(action: {
                    NSApplication.shared.terminate(self)
                }, label: {
                    Text("Quit Gitimoji")
                }).buttonStyle(BorderlessButtonStyle())
                .padding(.bottom, 5)
            }.padding(.vertical, 5)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
