//
//  GeneralSettingsView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 24.09.22.
//

import SwiftUI
import KeyboardShortcuts

struct GeneralSettingsView: View {
    @ObservedObject var updater: Updater
    @ObservedObject var fetcher: GitmojiFetcher

    @Binding var autoLaunchEnabled: Bool

    @AppStorage("copyEmoji") private var copyEmoji = false

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
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
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(updater: .init(),
                            fetcher: .init(),
                            autoLaunchEnabled: .constant(false))
    }
}
