//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

class ErrorHandler: ObservableObject {
    @Published var currentHandlerItem: ErrorHandlerItem?

    func handle(error: Error?, handler: (() -> Bool)? = nil) {
        guard let error = error else { return }
        
        Logger.error("\(error.localizedDescription)")
        
        if handler?() == true {
            return
        }
        
        currentHandlerItem = ErrorHandlerItem(error: error)
    }
}
