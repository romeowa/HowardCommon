//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public extension Double {
    var toDate: Date {
        return Date(timeIntervalSince1970: (self / 1000))
    }
    
    var secondToTimeString: String {
        let intValue = Int(self)
        let hours = intValue / 3600
        let minutes = intValue / 60 % 60
        let seconds = intValue % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var secondToTimeString2: String {
        let intValue = Int(self)
        let hours = intValue / 3600
        let minutes = intValue / 60 % 60
        let seconds = intValue % 60
        
        return String(format: "%0d:%02d:%02d", hours, minutes, seconds)
    }
    
    var secondToTimeString3: String {
        let intValue = Int(self)
        let hours = intValue / 3600
        let minutes = intValue / 60 % 60
        let seconds = intValue % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
