//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public enum Errors {
    public enum ValidationError: LocalizedError {
        case nilValue(String)
        case nilOrEmpty(String)
        
        public var errorDescription: String? {
            switch self {
            case let .nilValue(property):
                return "nil: \(property)"
            case let .nilOrEmpty(property):
                return "nil or empty: \(property)"
            }
        }
    }
    
    public enum CommonError: LocalizedError {
        case notImplemented
        case justError(String)
        
        public var errorDescription: String? {
            switch self {
            case .notImplemented:
                return "구현 안 됨"
            case let .justError(errorString):
                return "\(errorString)"
            }
        }
    }
    
    public enum ApiError: LocalizedError {
        case reLogin
        case inReauth
        case maintanance
        case needToUpdate
        case serverError(Int, String)
        
        public var errorDescription: String? {
            switch self {
            case .reLogin:
                return "재인증 필요"
            case .inReauth:
                return "자동 재인증 진행 중"
            case .maintanance:
                return "점검 중"
            case .needToUpdate:
                return "업데이트 필요"
            case let .serverError(code, message):
                return "\(message)\n(\(code))"
            }
        }
    }
}
