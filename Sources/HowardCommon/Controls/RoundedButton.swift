//
//  RoundedButton.swift
//
//
//  Created by howard on 11/1/23.
//

import Foundation
import SwiftUI

public struct RoundedButton<Label: View>: View {
    public enum Theme {
        case blue
        case gray
    }
    
    @Binding var enabled: Bool
    var theme: Theme = .blue
    var action: () async -> Void
    @ViewBuilder var label: () -> Label
    
    @State private var performingTask = false
    @State private var opacity = 1.0
    @State private var size: CGSize = .zero
    @GestureState private var isTapped = false
    
    public init(enabled: Binding<Bool> = .constant(true), theme: Theme = .blue, action: @escaping () async -> Void, label: @escaping () -> Label) {
        _enabled = enabled
        self.theme = theme
        self.action = action
        self.label = label
    }
    
    
    public var body: some View {
        ZStack {
            if performingTask == true {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(width: size.width, height: size.height)
            } else {
                label()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: size.height / 2)
                .foregroundColor(enabled ?
                                 (theme == .blue ? .blue : .gray) :
                        .gray)
                .clipShape(RoundedRectangle(cornerRadius: size.height / 2))
                .frame(height: size.height)
        )
        .contentShape(Rectangle())
        .readSize { size in
            self.size = size
        }
        .opacity(opacity)
        .onTapGesture {
            if enabled == false || performingTask == true {
                return
            }
            
            Task {
                performingTask = true
                await action()
                performingTask = false
            }
        }
        .simultaneousGesture (
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if enabled == true {
                        opacity = 0.8
                    }
                }
                .onEnded{ _ in
                    if enabled == true {
                        opacity = 1.0
                    }
                }
        )
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(theme: .gray) {
            
        } label: {
            HStack {
                Spacer()
                Text("abc")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 20)
        
    }
}

