//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
        return jsonData as? [String: Any]
    }

    func toJSONString() throws -> String? {
        let data = try JSONEncoder().encode(self)
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
