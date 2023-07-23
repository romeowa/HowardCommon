//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

struct FullScreenCoverItem: Identifiable {
    var id = UUID()
    var contentView: AnyView
}

extension FullScreenCoverItem: Equatable {
    static func == (lhs: FullScreenCoverItem, rhs: FullScreenCoverItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct FullScreenCoverModifier: ViewModifier {
    @Binding var item: FullScreenCoverItem?

    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $item, content: { item in
                item.contentView
            })
    }
}

extension View {
    func showFullScreenCover(item: Binding<FullScreenCoverItem?>) -> some View {
        modifier(FullScreenCoverModifier(item: item))
    }
}

