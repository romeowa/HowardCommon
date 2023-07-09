//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public struct FloatingViewModifier: ViewModifier {
    @Binding var offset: CGSize
    @State var oldTranslation = CGSize.zero
    
    var onDragEnded: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .offset(x: offset.width, y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let gap = CGSize(width: value.translation.width - oldTranslation.width, height: value.translation.height - oldTranslation.height)
                        offset = CGSize(width: offset.width + gap.width, height: offset.height + gap.height)
                        oldTranslation = value.translation
                    })
                    .onEnded({ value in
                        oldTranslation = CGSize(width: 0, height: 0)
                        onDragEnded?()
                    })
            )
    }
}

public extension View {
    func floating(offset: Binding<CGSize>, onDragEnded: (() -> Void)? = nil) -> some View {
        modifier(FloatingViewModifier(offset: offset, onDragEnded: onDragEnded))
    }
}
