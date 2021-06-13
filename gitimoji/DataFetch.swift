//
//  DataFetch.swift
//  gitimoji
//
//  Created by Timo Zacherl on 13.06.21.
//

import Foundation

fileprivate struct Response: Decodable {
    let gitmojis: [GitmojiResponse]
}

struct GitmojiResponse: Decodable {
    let emoji, entity, code, description: String
    let name: String
    let semver: Semver?
}

enum Semver: String, Decodable {
    case major = "major"
    case minor = "minor"
    case patch = "patch"
}

func fetchEmojis(completionHandler: @escaping ([GitmojiResponse]) -> Void) -> Void {
    let url = URL(string: "https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/data/gitmojis.json")
    
    guard let url = url else {
        print("url invalid or not provided")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error while fetching gitmojis from github repo: \(error)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Unexpected response: \(String(describing: response))")
            return
        }

        if let data = data, let emojiResponse = try? JSONDecoder().decode(Response.self, from: data) {
            completionHandler(emojiResponse.gitmojis)
        }
    }
    
    task.resume()
}
