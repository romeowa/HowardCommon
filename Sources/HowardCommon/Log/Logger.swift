//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public class Logger: ObservableObject {
    public static var shared = Logger()
    @Published public var logs = [LogItem]()
    public init() {
        
    }
    
    private func addLog(_ log: LogItem) {
        print("\(log.desciption())")
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
    
    public static func warnning(_ message: String, service: LogItem.Service = .default) {
        Logger.shared.addLog(LogItem(message: message, level: .warnning, service: service))
    }
    
    public static func error(_ message: String, service: LogItem.Service = .default) {
        Logger.shared.addLog(LogItem(message: message, level: .error, service: service))
    }
    
    public static func clear() {
        Logger.shared.logs.removeAll()
    }
}
