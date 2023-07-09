//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import CoreMedia

public extension Int {
    var stringValue: String {
        "\(self)"
    }
    
    var millieSecondToSecond: Int {
        return self / 1000
    }
    
    var millieSecondToKoreanTimeString: String {
        let hour =  self / 1000 / 60 / 60
        let minute = self / 1000 / 60
        let second = self / 1000 % 60
        
        var result = ""
        
        if hour > 0 {
            result.append("\(hour)시 ")
        }
        
        if minute > 0 {
            result.append("\(minute)분 ")
        }
        
        if second > 0 {
            result.append("\(second)초")
        }
        
        return result
    }
    
    var millieSecondToTimeString: String {
        let hour =  self / 1000 / 60 / 60
        let minute = self / 1000 / 60
        let second = self / 1000 % 60
        
        var result = ""
        
        if hour > 0 {
            result.append(String(format: "%02d:", hour))
        }
        
        result.append(String(format: "%02d:", minute))
        result.append(String(format: "%02d", second))
        
        return result
    }
    
    var secondToTimeString: String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var dataSizeString: String {
        var floatSize = Float(self)
        if self < 1024 {
            return ("\(self)B")
        }
        
        floatSize /= 1024.0
        if floatSize < 1024 {
            return (String(format: "%.1fKB", floatSize))
        }
        
        floatSize /= 1024.0
        if floatSize < 1024 {
            return (String(format: "%.1fMB", floatSize))
        }
        
        floatSize /= 1024.0
        return (String(format: "%.1fGB", floatSize))
    }
    
    var secondToKoreanTimeString: String {
        let hour =  self / 60 / 60
        let minute = self / 60
        let second = self % 60
        
        var result = ""
        
        if hour > 0 {
            result.append("\(hour)시 ")
        }
        
        if minute > 0 {
            result.append("\(minute)분 ")
        }
        
        if second > 0 {
            result.append("\(second)초")
        }
        
        return result
    }
}


public extension Int { //for vito
    var fileSizeToTimeString: String {
        if self <= 0 {
            return "0분"
        }
        let value = Int(MathHelper.logC(val: Double(self), forBase: 1024))
        if value == 2 || value == 3 {
            let totalMinutes = self / (pow(1024, 2) as NSDecimalNumber).intValue
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            
            return "\(hours > 0 ? "\(hours)시간 " : "")\(minutes > 0 ? "\(minutes)분" : "")"
        } else {
            return "0분"
        }
    }
}


public extension Int { //file size
    var byteToGigaByte: Int {
        self / 1024 / 1024 / 1024
    }
}
