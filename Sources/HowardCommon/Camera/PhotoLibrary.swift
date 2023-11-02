//
//  PhotoLibrary.swift
//  TextExtractor
//
//  Created by howard on 10/31/23.
//

import Photos

class PhotoLibrary {

    static func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            Logger.debug("Photo library access authorized.")
            return true
        case .notDetermined:
            Logger.debug("Photo library access not determined.")
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:
            Logger.debug("Photo library access denied.")
            return false
        case .limited:
            Logger.debug("Photo library access limited.")
            return false
        case .restricted:
            Logger.debug("Photo library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
}
