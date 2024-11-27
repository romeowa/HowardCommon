//
//  File.swift
//
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

public struct ContentToastItem: OverlayModifierPresentable {
    public var id = UUID()
    public let contentView: AnyView
    
    public init(id: UUID = UUID(), contentView: AnyView) {
        self.id = id
        self.contentView = contentView
    }
    
    public static func == (lhs: ContentToastItem, rhs: ContentToastItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    public func showContentToast(item: Binding<ContentToastItem?>, duration: TimeInterval = 1.0) -> some View {
        modifier(OverlayModifier(item: item, overlayContent: ContentToastItemView(toastItem: item, duration: duration), allowUserInteraction: false))
    }
}

struct ContentToastItemView: View {
    @Binding var toastItem: ContentToastItem?
    var duration: TimeInterval
    
    var body: some View {
        VStack {
            Spacer()
            if let contentView = toastItem?.contentView {
                contentView
            } else {
                Group {
                    Text("에러")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 12.5)
                        .padding(.horizontal, 20)
                }
                .background(Colors.gray300)
                .cornerRadius(4)
            }
        }
        .animation(.linear(duration: 0.3), value: toastItem)
        .transition(.opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                toastItem = nil
            }
        }
    }
}
