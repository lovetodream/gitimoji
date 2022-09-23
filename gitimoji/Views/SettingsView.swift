//
//  SwiftUIView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 22.09.20.
//

import SwiftUI
import KeyboardShortcuts
import ServiceManagement

struct SettingsView: View {
    @StateObject private var updater = Updater()
    @StateObject private var fetcher = GitmojiFetcher()

    @State private var autoLaunchEnabled = false

    @AppStorage("copyEmoji") private var copyEmoji = false

    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(spacing: 15) {
            TabView {
                VStack(spacing: 10) {
                    Picker(selection: $copyEmoji, label: Text("Value to copy")) {
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
                            if fetcher.state != .loading {
                                Task {
                                    await fetcher.refetch(on: viewContext)
                                }
                            }
                        } label: {
                            switch fetcher.state {
                            case .stateless:
                                Text("Start fetch")
                            case .loading:
                                Text("Fetching...")
                            case .success:
                                Text("✅ Success")
                            case .error:
                                Text("🛑 Error occurred")
                            }
                        }
                        .disabled(fetcher.state == .loading)
                    }

                    HStack {
                        Spacer()
                        Toggle(isOn: $autoLaunchEnabled) {
                            Text("Launch App automatically")
                        }
                    }

                    HStack {
                        Spacer()
                        Button {
                            updater.checkForUpdates()
                        } label: {
                            Text("Check for updates...")
                        }
                        .disabled(!updater.canCheckForUpdates)
                    }

                    Spacer()
                }
                .padding()
                .tabItem {
                    Label("General", systemImage: "gear")
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Gitmoji is an emoji guide for GitHub commit messages. Aims to be a standarization cheatsheet - guide for using emojis on GitHub's commit messages.")

                    Text("Using emojis on commit messages provides an easy way of identifying the purpose or intention of a commit with only looking at the emojis used.")

                    Spacer()

                }
                .lineSpacing(1.5)
                .padding()
                .tabItem {
                    Label("About", systemImage: "info")
                }
            }

            HStack(spacing: 15) {
                Link("Gitmoji Website", destination: Constants.Link.gitmoji)

                Spacer()

                Link("Star on GitHub", destination: Constants.Link.repository)

                Button {
                    if let url = URL(string: "https://github.com/sponsors/lovetodream") {
                        NSWorkspace.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.pink)
                        Text("Sponsor")
                    }
                }
                .buttonStyle(.bordered)
            }
            .buttonStyle(.link)
        }
        .padding()
        .onAppear {
            autoLaunchEnabled = NSWorkspace.shared.runningApplications.contains {
                $0.bundleIdentifier == Constants.helperBundleIdentifier
            }
        }
        .onChange(of: autoLaunchEnabled) { newValue in
            SMLoginItemSetEnabled(Constants.helperBundleIdentifier as CFString, newValue)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 350)
    }
}
