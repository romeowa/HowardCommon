//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public extension Data {
    var jsonObject: Any? {
        guard isEmpty == false else {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: self)
            return json
        } catch {
            return nil
        }
    }
    
    var toDictionary: [String: Any]? {
        return jsonObject as? [String: Any]
    }
}
