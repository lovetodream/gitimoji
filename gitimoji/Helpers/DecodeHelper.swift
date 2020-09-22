//
//  DecodeHelper.swift
//  gitimoji
//
//  Created by Timo Zacherl on 19.09.20.
//

import Foundation

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not locate \(file) inside the bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from the bundle")
        }
        
        let decoder = JSONDecoder()
        
        // MARK: - Debugging
        // let result = try! decoder.decode(T.self, from: data)
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from the bundle")
        }
        
        return result
        
    }
    
}
