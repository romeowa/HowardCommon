//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
    }
    
    mutating func appendQueryItems(with parameters: [String: String]) {
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
        for queryItem in  queryItems {
            self.queryItems?.append(queryItem)
        }
    }
}
