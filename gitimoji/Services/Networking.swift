//
//  Networking.swift
//  gitimoji
//
//  Created by Timo Zacherl on 13.06.21.
//

import Foundation

private struct Response: Decodable {
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

enum NetworkingError: LocalizedError {
    case invalidResponse(context: String?)

    var errorDescription: String? {
        switch self {
        case .invalidResponse(let context):
            return context ?? "Unexpected response received."
        }
    }
}

enum Networking {
    static func fetchEmojis() async throws -> [GitmojiResponse] {
        let url = UserDefaults.standard.url(forKey: Constants.DefaultKey.gitmojiFetchURL.rawValue) ??
            URL(string: "https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json")

        guard let url else {
            preconditionFailure("Gitmoji fetch URL invalid")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkingError.invalidResponse(
                context: "Unexpected response received: \(String(data: data, encoding: .utf8) ?? "empty")"
            )
        }

        return try JSONDecoder().decode(Response.self, from: data).gitmojis
    }
}
