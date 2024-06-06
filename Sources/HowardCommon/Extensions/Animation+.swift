//
//  File.swift
//  
//
//  Created by howard on 5/30/24.
//

import SwiftUI

extension Animation {
    public func curve(_ curve: UIView.AnimationCurve) -> Animation {
        switch curve {
            case .easeInOut:
                return .easeInOut
            case .easeIn:
                return .easeIn
            case .easeOut:
                return .easeOut
            case .linear:
                return .linear
            @unknown default:
                return .easeInOut
        }
    }
}
