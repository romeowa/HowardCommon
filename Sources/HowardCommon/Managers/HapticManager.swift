//
//  HapticManager.swift
//
//
//  Created by howard on 11/2/23.
//

import UIKit

public class HapticManager: NSObject {
    public static var `default` = HapticManager()
    
    public func notification(withType type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    public func impact(witihStyle style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    public func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

