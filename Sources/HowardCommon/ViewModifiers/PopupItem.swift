//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

struct PopupItem: OverlayModifierPresentable {
    var id = UUID()
    let contentView: AnyView
    var opacity: Double?
    var dismissByBackground = false
    var alignment: Alignment = .center
    
    static func == (lhs: PopupItem, rhs: PopupItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    func showPopup(item: Binding<PopupItem?>) -> some View {
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

