//
//  AlertManager.swift
//  
//
//  Created by howard on 2023/07/22.
//

import Foundation

class AlertManager {
    static let manager = AlertManager()
    @Published var popupItem: PopupItem?
    @Published var toastItem: ToastItem?
    @Published var alertItem: AlertItem?
    @Published var fullScreenCoverItem: FullScreenCoverItem?
    @Published var bottomSheetItem: BottomSheetItem?
    
    func showPopup(_ item: PopupItem) {
        self.popupItem = item
    }
    
    func closePopup() {
        popupItem = nil
    }
    
    func showAlert(_ item: AlertItem) {
        self.alertItem = item
    }
    
    func showToast(_ item: ToastItem) {
        self.toastItem = item
    }
    
    func showFullScreenCover(_ item: FullScreenCoverItem) {
        self.fullScreenCoverItem = item
    }
    
    func closeFullScreenCover() {
        self.fullScreenCoverItem = nil
    }
    
    func showBottomSheet(_ item: BottomSheetItem) {
        self.bottomSheetItem = item
    }
    
    func closeBottomSheetItem() {
        self.bottomSheetItem = nil
    }
}
