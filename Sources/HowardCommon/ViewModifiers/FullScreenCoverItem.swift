//
//  File.swift
//  
//
//  Created by howard on 2023/07/23.
//

import Foundation
import SwiftUI

public struct FullScreenCoverItem: Identifiable {
    public var id = UUID()
    public var contentView: AnyView
}

extension FullScreenCoverItem: Equatable {
    public static func == (lhs: FullScreenCoverItem, rhs: FullScreenCoverItem) -> Bool {
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
    public func showFullScreenCover(item: Binding<FullScreenCoverItem?>) -> some View {
        modifier(FullScreenCoverModifier(item: item))
    }
}

