//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import StoreKit

class AppStoreManager {
    static let manager = AppStoreManager()
    
    func showReviewView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

