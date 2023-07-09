//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

enum Errors {
    enum ValidationError: LocalizedError {
        case nilValue(String)
        case nilOrEmpty(String)
        
        var errorDescription: String? {
            switch self {
            case let .nilValue(property):
                return "nil: \(property)"
            case let .nilOrEmpty(property):
                return "nil or empty: \(property)"
            }
        }
    }
    
    enum CommonError: LocalizedError {
        case notImplemented
        case justError(String)
        
        var errorDescription: String? {
            switch self {
            case .notImplemented:
                return "구현 안 됨"
            case let .justError(errorString):
                return "\(errorString)"
            }
        }
    }
}
