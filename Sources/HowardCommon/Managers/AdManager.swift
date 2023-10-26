//
//  AdManager.swift
//
//
//  Created by howard on 10/20/23.
//

import Foundation
import AdSupport
import AppTrackingTransparency

public class AdManager: NSObject {
    public static let `default` = AdManager()
    public func requestPermission() async -> ATTrackingManager.AuthorizationStatus {
        await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                continuation.resume(returning: status)
//                switch status {
//                case .authorized:
//                    continuation.resume(returning: status)
//                    // Tracking authorization dialog was shown
//                    // and we are authorized
//                    print("Authorized")
//                    // Now that we are authorized we can get the IDFA
//                print(ASIdentifierManager.shared().advertisingIdentifier)
//                case .denied:
//                   // Tracking authorization dialog was
//                   // shown and permission is denied
//                     print("Denied")
//                case .notDetermined:
//                        // Tracking authorization dialog has not been shown
//                        print("Not Determined")
//                case .restricted:
//                        print("Restricted")
//                @unknown default:
//                        print("Unknown")
//                }
            }
        }
        
    }

}

