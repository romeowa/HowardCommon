//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

public struct AlertItem: OverlayModifierPresentable {
    public init(id: UUID = UUID(), title: String = "", message: String = "", primaryButton: Alert.Button? = nil, secondaryButton: Alert.Button? = nil) {
        self.id = id
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
    
    public var id = UUID()
    public var title = ""
    public var message = ""
    public var primaryButton: Alert.Button?
    public var secondaryButton: Alert.Button?
    
    public static func == (lhs: AlertItem, rhs: AlertItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    public func showAlert(item: Binding<AlertItem?>) -> some View {
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
