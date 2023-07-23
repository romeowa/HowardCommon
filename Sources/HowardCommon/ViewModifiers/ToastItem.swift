//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

struct ToastItem: OverlayModifierPresentable {
    var id = UUID()
    var message = ""
    
    static let commonErrorToastItem = ToastItem(message: "에러")
}

extension View {
    func showToast(item: Binding<ToastItem?>) -> some View {
        modifier(OverlayModifier(item: item, overlayContent: ToastView(toastItem: item), allowUserInteraction: false))
    }
}

struct ToastView: View {
    @Binding var toastItem: ToastItem?
    
    var body: some View {
        VStack {
            Spacer()
            if let message = toastItem?.message {
                Group {
                    Text(message)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(Colors.whiteGray700)
                        .padding(.vertical, 12.5)
                        .padding(.horizontal, 20)
                }
                .background(Colors.gray700White)
                .cornerRadius(4)
            }
        }
        .padding()
        .animation(.linear(duration: 0.3), value: toastItem)
        .transition(.opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                toastItem = nil
            }
        }
    }
}
