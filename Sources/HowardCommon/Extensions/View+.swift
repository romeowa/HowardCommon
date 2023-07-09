//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            })
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func readFrame(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: geometryProxy.frame(in: .global))
            })
        .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
}


private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}


private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    }
}
