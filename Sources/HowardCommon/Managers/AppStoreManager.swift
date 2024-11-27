//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import StoreKit

public class AppStoreManager {
    public static let manager = AppStoreManager()
    
    public func showReviewView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

