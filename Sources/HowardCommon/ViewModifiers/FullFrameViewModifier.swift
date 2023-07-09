//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import SwiftUI

public struct FullFrameViewModifier: ViewModifier {
    public init() {
    }
    
    public func body(content: Content) -> some View {
        content
            .frame(
                  minWidth: 0,
                  maxWidth: .infinity,
                  minHeight: 0,
                  maxHeight: .infinity,
                  alignment: .topLeading
                )
    }
}

