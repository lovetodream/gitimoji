//
//  Networking.swift
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

enum NetworkingError: Error {
    case invalidResponse
}

struct Networking {
    static func fetchEmojis() async throws -> [GitmojiResponse] {
        let url = URL(string: "https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json")

        guard let url = url else {
            preconditionFailure("Gitmoji fetch URL invalid")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Unexpected response: \(String(describing: response))")
            throw NetworkingError.invalidResponse
        }

        return try JSONDecoder().decode(Response.self, from: data).gitmojis
    }
}
