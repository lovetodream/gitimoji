//
//  SwiftUIView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 22.09.20.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @ObservedObject var vm: SearchVM
    
    @Binding var copyEmojiBinding: Bool
    @Binding var showSettings: Bool
    @Binding var showAbout: Bool
    @State var fetchSuccessful: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Settings").font(.headline)
                Spacer()
                Button(action: {
                    self.showSettings = false
                }, label: {
                    Image("DismissIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }).buttonStyle(PlainButtonStyle())
            }
            Picker(selection: $copyEmojiBinding, label: Text("Value to copy")) {
                Text("Emoji Code eg. :tada:").tag(false)
                Text("Emoji eg. 🎉").tag(true)
            }
            HStack {
                Text("Toggle App Window")
                Spacer()
                KeyboardShortcuts.Recorder(for: .toggleApp)
            }
            HStack {
                Text("Fetch new gitmojis")
                Spacer()
                Button {
                    if vm.fetchState != .loading {
                        vm.refetchGitmojis()
                    }
                } label: {
                    switch vm.fetchState {
                    case .stateless:
                        Text("Start fetch")
                    case .loading:
                        Text("Fetching...")
                    case .success:
                        Text("✅ Success")
                    case .error:
                        Text("🛑 Error occurred")
                    }
                }.disabled(vm.fetchState == .loading)
            }
            Toggle(isOn: $vm.autoLaunchEnabled) {
                Text("Launch App automatically")
            }
            Button(action: {
                self.showAbout.toggle()
            }, label: {
                if showAbout {
                    Text("Hide additional informations")
                } else {
                    Text("More Informations about Gitmojis")
                }
            }).buttonStyle(LinkButtonStyle())
            if showAbout {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gitmoji is an emoji guide for GitHub commit messages. Aims to be a standarization cheatsheet - guide for using emojis on GitHub's commit messages.")
                                        
                    Text("Using emojis on commit messages provides an easy way of identifying the purpose or intention of a commit with only looking at the emojis used.")
                    
                }
                .frame(minHeight: 135)
                .lineSpacing(1.5)
            }
            
            Divider()
            
            HStack {
                Button(action: {
                    if let url = URL(string: "https://gitmoji.dev/") {
                    NSWorkspace.shared.open(url)
                    }
                }, label: {
                    Text("Gitmoji Website")
                })
                
                Spacer()
                
                Button(action: {
                    if let url = URL(string: "https://github.com/lovetodream/gitimoji") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("Star on GitHub")
                }
            }
        }
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.black.opacity(0.1), lineWidth: 2.0))
        .cornerRadius(10.0)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vm: SearchVM(), copyEmojiBinding: .constant(false), showSettings: .constant(true), showAbout: .constant(true))
            .frame(width: 350)
    }
}
