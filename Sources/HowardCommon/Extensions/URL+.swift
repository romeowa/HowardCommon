//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import AVKit

extension URL {
    public func getDurationFromLocalfile() -> Float {
        let audioAsset = AVURLAsset(url: self)
        let duration = Float(CMTimeGetSeconds(audioAsset.duration))
        return duration
    }
    
    public var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}
