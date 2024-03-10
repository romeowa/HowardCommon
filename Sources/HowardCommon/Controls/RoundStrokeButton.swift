//
//  RoundStrokeButton.swift
//
//
//  Created by howard on 11/14/23.
//

import SwiftUI

public struct RoundStrokeButton<Label: View>: View {
    var enabled: Bool = true
    var cornerRadius: CGFloat
    var lineWidth: CGFloat
    var lineColor: Color
    var action: () -> Void
    @ViewBuilder var label: () -> Label
    
    public init(enabled: Bool = true, 
                cornerRadius: CGFloat = 8.0,
                lineWidth: CGFloat = 1.0,
                lineColor: Color = Color(red: 0.929, green: 0.929, blue: 0.929), action: @escaping () -> Void, label: @escaping () -> Label) {
        self.enabled = enabled
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        BaseButton(enabled: enabled) {
            action()
        } label: {
            label()
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(lineColor, lineWidth: 1.0)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                )
                .contentShape(Rectangle())
        }
    }
}

struct RoundStrokeButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundStrokeButton {
            
        } label: {
            HStack {
                Spacer()
                Text("hi")
                    .padding(.vertical, 12)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}


