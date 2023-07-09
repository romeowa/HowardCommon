//
//  BaseButton.swift
//  
//
//  Created by howard on 2023/07/09.
//

import SwiftUI

public struct BaseButton<Label: View>: View {
    var enabled: Bool
    var action: () -> Void
    @ViewBuilder var label: () -> Label
    
    public init(enabled: Bool = true , action: @escaping () -> Void, label: @escaping () -> Label) {
        self.enabled = enabled
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        Button {
            if enabled {
                action()
            }
        } label: {
            label()
                .contentShape(Rectangle())
        }
        .buttonStyle(BaseButtonStyle())
    }
}

struct BaseButton_Previews: PreviewProvider {
    @State static var enabled = true
    static var previews: some View {
        BaseButton(enabled: enabled) {
            
        } label: {
            Text("abc")
                .foregroundColor(enabled ? .red : .green)
        }
    }
}


struct BaseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
