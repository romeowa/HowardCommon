//
//  File.swift
//
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public struct HandleErrorsByShowingAlertViewModifier: ViewModifier {
    @StateObject var errorHandler: ErrorHandler
    var dismissAction: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .alert(isPresented: $errorHandler.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorHandler.message),
                    dismissButton: .default(Text("확인"), action: {
                        dismissAction?()
                    }))
            }
    }
}

extension View {
    public func showAlertWithErrorHadler(_ errorHandling: ErrorHandler, dismissAction: (() -> Void)? = nil ) -> some View {
        modifier(
            HandleErrorsByShowingAlertViewModifier(
                errorHandler: errorHandling,
                dismissAction: dismissAction
            )
        )
    }
}
