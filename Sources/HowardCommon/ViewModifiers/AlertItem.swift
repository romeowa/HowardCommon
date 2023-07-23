//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

struct AlertItem: OverlayModifierPresentable {
    var id = UUID()
    var title = ""
    var message = ""
    var primaryButton: Alert.Button?
    var secondaryButton: Alert.Button?
    
    static func == (lhs: AlertItem, rhs: AlertItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    func showAlert(item: Binding<AlertItem?>) -> some View {
        modifier(OverlayModifier(item: item, overlayContent: AlertView(alertItem: item)))
    }
}

struct AlertView: View {
    @Binding var alertItem: AlertItem?
    
    var body: some View {
        EmptyView()
            .alert(item: $alertItem) { item in
                guard let primaryButton = item.primaryButton else {
                    return Alert(title: Text(item.title),
                                 message: Text(item.message))
                }
                
                if let secondaryButton = item.secondaryButton {
                    return Alert(title: Text(item.title),
                                 message: Text(item.message),
                                 primaryButton: primaryButton,
                                 secondaryButton: secondaryButton)
                } else {
                    return Alert(title: Text(item.title),
                                 message: Text(item.message),
                                 dismissButton: primaryButton)
                }
            }
    }
}
