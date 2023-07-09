//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

struct HandleErrorsByShowingAlertViewModifier: ViewModifier {
    @ObservedObject var errorHandler: ErrorHandler
    var dismissAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $errorHandler.currentHandlerItem) { currentHandlerItem in
                Alert(
                    title: Text("에러"),
                    message: Text(currentHandlerItem.message),
                    dismissButton: .default(Text("확인")) {
                        dismissAction?()
                    }
                )
            }
    }
}

extension View {
    func showAlertWithErrorHadler(_ errorHandling: ErrorHandler, dismissAction: (() -> Void)? = nil ) -> some View {
        modifier(HandleErrorsByShowingAlertViewModifier(errorHandler: errorHandling, dismissAction: dismissAction))
    }
}
