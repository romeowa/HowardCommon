//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public class ErrorHandler: ObservableObject {
    @Published public var showAlert: Bool = false
    @Published public var message: String = ""

    // 외부 모듈에서 생성 가능하도록 public init 추가
    public init() {}

    public func handle(error: Error?, handler: (() -> Bool)? = nil) {
        guard let error = error else { return }
        
        Logger.error("error: \(error.localizedDescription)")
        
        if handler?() == true {
            return
        }
        
        message = error.localizedDescription
        showAlert = true
    }
}
