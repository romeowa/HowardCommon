//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import os

public class Logger: ObservableObject {
    public static var shared = Logger()
    @Published public var logs = [LogItem]()
    
    let logger = os.Logger(subsystem: "home.sweet.nunigu", category: "common")
    
    public init() {
        
    }
    
    private func addLog(_ log: LogItem) {
        
        switch log.level {
        case .verbose:
            logger.debug("\(log.desciption())")
        case .debug:
            logger.debug("\(log.desciption())")
        case .warning:
            logger.error("\(log.desciption())")
        case .error:
            logger.fault("\(log.desciption())")
        }

        DispatchQueue.main.async {
            Logger.shared.logs.append(log)
        }
    }
    
    public static func verbose(_ message: String, service: LogItem.Service = .default) {
        Logger.shared.addLog(LogItem(message: message, level: .verbose, service: service))
    }
    
    public static func debug(_ message: String, service: LogItem.Service = .default) {
        Logger.shared.addLog(LogItem(message: message, level: .debug, service: service))
    }
    
    public static func warning(_ message: String, service: LogItem.Service = .default) {
        Logger.shared.addLog(LogItem(message: message, level: .warning, service: service))
    }
    
    public static func error(_ message: String, service: LogItem.Service = .default) {
        Logger.shared.addLog(LogItem(message: message, level: .error, service: service))
    }
    
    public static func clear() {
        Logger.shared.logs.removeAll()
    }
}

