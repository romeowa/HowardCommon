//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public class ErrorHandler: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var message: String = ""
    
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
