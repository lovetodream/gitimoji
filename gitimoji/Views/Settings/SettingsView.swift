//
//  SwiftUIView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 22.09.20.
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @StateObject private var updater = Updater()
    @StateObject private var fetcher = GitmojiFetcher()

    @State private var autoLaunchEnabled = false
    
    var body: some View {
        VStack(spacing: 15) {
            TabView {
                GeneralSettingsView(updater: updater,
                                    fetcher: fetcher,
                                    autoLaunchEnabled: $autoLaunchEnabled)
                    .padding()
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }

                AboutView()
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
