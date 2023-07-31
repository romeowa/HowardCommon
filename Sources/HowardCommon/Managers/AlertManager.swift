//
//  AlertManager.swift
//  
//
//  Created by howard on 2023/07/22.
//

import Foundation

public class AlertManager: ObservableObject {
    public static let manager = AlertManager()
    
    @Published public var popupItem: PopupItem?
    @Published public var toastItem: ToastItem?
    @Published public var alertItem: AlertItem?
    @Published public var fullScreenCoverItem: FullScreenCoverItem?
    @Published public var bottomSheetItem: BottomSheetItem?
    
    public func showPopup(_ item: PopupItem) {
        self.popupItem = item
    }
    
    public func closePopup() {
        popupItem = nil
    }
    
    public func showAlert(_ item: AlertItem) {
        self.alertItem = item
    }
    
    public func showToast(_ item: ToastItem) {
        self.toastItem = item
    }
    
    public func showFullScreenCover(_ item: FullScreenCoverItem) {
        self.fullScreenCoverItem = item
    }
    
    public func closeFullScreenCover() {
        self.fullScreenCoverItem = nil
    }
    
    public func showBottomSheet(_ item: BottomSheetItem) {
        self.bottomSheetItem = item
    }
    
    public func closeBottomSheetItem() {
        self.bottomSheetItem = nil
    }
}
