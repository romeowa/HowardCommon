//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

public struct PopupItem: OverlayModifierPresentable {
    public var id = UUID()
    public let contentView: AnyView
    public var opacity: Double?
    public var dismissByBackground = false
    public var alignment: Alignment = .center
    
    public static func == (lhs: PopupItem, rhs: PopupItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    public func showPopup(item: Binding<PopupItem?>) -> some View {
        modifier(OverlayModifier(item: item, overlayContent: PopupBaseView(popupItem: item)))
    }
}

struct PopupBaseView: View {
    @Binding var popupItem: PopupItem?

    var body: some View {
        if let view = popupItem?.contentView {
            ZStack(alignment: popupItem?.alignment ?? .center) {
                Color.black.opacity(popupItem?.opacity ?? 0.4)
                    .onTapGesture {
                        if popupItem?.dismissByBackground == true {
                            popupItem = nil
                        }
                    }
                view
            }
            .ignoresSafeArea()
            .transition(.opacity.animation(.linear(duration: 0.2)))
        } else {
            EmptyView()
        }
    }
}

