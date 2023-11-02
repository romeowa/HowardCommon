//
//  PhotoManager.swift
//  
//
//  Created by howard on 10/31/23.
//

import UIKit
import Photos

class PhotoManager: NSObject {
    static let `default` = PhotoManager()
    
    func saveImage(`with` image: UIImage) async throws -> Void {
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Void, Error>) -> Void in
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges {
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    } completionHandler: { success, error in
                        if let error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume()
                        }
                    }
                } else {
                    continuation.resume(throwing: Errors.CommonError.justError("사진 접근 권한이 없습니다."))
                }
            }
        })
    }
}

