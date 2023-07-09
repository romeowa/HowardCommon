//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

struct ErrorHandlerItem: Identifiable {
    var id = UUID()
    var error: Error
    var message: String {
        return error.localizedDescription
    }
}
