//
//  File.swift
//
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public class LogItem: ObservableObject, Identifiable {
    public enum Level: Int {
        case verbose
        case debug
        case warning
        case error
        
        var description: String {
            switch self {
                case .verbose:
                    return "[💬]"
                case .debug:
                    return "[🐞]"
                case .warning:
                    return "[⚠️]"
                case .error:
                    return "[👺]"
            }
        }
    }
    
    public enum Service: String {
        case `default` = "[DF]"
        case control = "[CT]"
        case auth = "[AT]"
        case soundCenter = "[SC]"
        case userAction = "[✨]"
    }
    
    public var id = UUID()
    
    var message: String
    var level: Level
    var servcie = Service.default
    var date: Date
    
    init(message: String, level: Level, service: Service) {
        self.message = message
        self.level = level
        self.servcie = service
        self.date = Date()
    }
    
    func desciption() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        
        return "\(level.description)\(servcie.rawValue)[\(dateFormatter.string(from: date))]: \(message)"
    }
}

