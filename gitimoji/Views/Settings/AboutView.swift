//
//  AboutView.swift
//  gitimoji
//
//  Created by Timo Zacherl on 24.09.22.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gitmoji is an emoji guide for GitHub commit messages. Aims to be a standarization cheatsheet - guide for using emojis on GitHub's commit messages.")

            Text("Using emojis on commit messages provides an easy way of identifying the purpose or intention of a commit with only looking at the emojis used.")

            Spacer()

        }
        .lineSpacing(1.5)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
