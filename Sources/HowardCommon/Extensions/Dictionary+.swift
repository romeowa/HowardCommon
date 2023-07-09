//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public extension Dictionary {
    var toData: Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            return data
        } catch {
            return nil
        }
    }
    
    var toString: String? {
        return self.toStringRemoveEscapeForwardSlashes(false)
    }
    
    var toStringRemoveEscapeForwardSlahes: String? {
        return self.toStringRemoveEscapeForwardSlashes(true)
    }
    
    func toStringRemoveEscapeForwardSlashes(_ willRemove: Bool) -> String? {
        guard let data = self.toData else { return nil }
        
        var string = String(data: data, encoding: .utf8)
        if willRemove {
            string = string?.replacingOccurrences(of: "\\/", with: "/")
        }
        
        return string
    }
}
