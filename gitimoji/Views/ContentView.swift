//
//  ContentView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = SearchVM()
    
    @State private var searchText: String = ""
    @State private var showSettings: Bool = false
    @State private var copyEmoji: Bool = Defaults.getSettings()
    @State private var showAbout = false
    
    var body: some View {
        let searchTextBinding = Binding( get: {
            return self.searchText
        }, set: {
            self.searchText = $0
            // search function here
            self.vm.updateSearchText(width: $0)
        })
        
        let copyEmojiBinding = Binding( get: {
            return self.copyEmoji
        }, set: {
            self.copyEmoji = $0
            Defaults.saveSettings(copyEmojiValue: $0)
        })
        
        return VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    ZStack {
                        Color(NSColor.controlBackgroundColor).frame(height: 22).cornerRadius(6)
                        
                        HStack {
                            Text("🔍")
                                .padding(.leading, 5)
                            
                            TextField("Search...", text: searchTextBinding)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            Group {
                                if !searchText.isEmpty {
                                    if vm.isLoading {
                                        Button(action: {
                                            self.searchText = ""
                                        }, label: {
                                            ProgressIndicator()
                                                .frame(width: 35, height: 35)
                                        })
                                    } else {
                                        Button(action: {
                                            self.searchText = ""
                                        }, label: {
                                            Image("DismissIcon")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.gray)
                                                .frame(width: 16, height: 16)
                                        }).buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }.padding(.trailing, 5)
                        }
                    }
                    
                    Button(action: {
                        self.showSettings.toggle()
                    }, label: {
                        Image("SettingsIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    })
                    .buttonStyle(PlainButtonStyle())
                }.padding(.bottom, 10)
                if showSettings {
                    SettingsView(vm: vm, copyEmojiBinding: copyEmojiBinding, showSettings: $showSettings, showAbout: $showAbout)
                }
                ScrollView {
                    ForEach(vm.searchResults) { gitmoji in
                        EmojiRow(gitmoji: gitmoji, copyEmoji: self.$copyEmoji)
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
