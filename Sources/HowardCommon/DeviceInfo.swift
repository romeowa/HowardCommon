//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import UIKit

public enum DeviceInfo {
    public static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    public static var friendlyDeviceName: String {
        return DeviceInfo.Generation(modelName: DeviceInfo.modelName)?.rawValue ?? ""
    }
    
    public static var getDeviceUUID: String {
        UIDevice.current.identifierForVendor!.uuidString
    }
}

public extension DeviceInfo {
    //https://www.theiphonewiki.com/wiki/Models
    enum Generation:  String, Equatable {
        case iPodTouch6 = "iPod Touch 6"
        case iPodTouch7 = "iPod touch 7"
        case iPhone4 = "iPhone 4"
        case iPhone4s = "iPhone 4s"
        case iPhone5 = "iPhone 5"
        case iPhone5c = "iPhone 5c"
        case iPhone5s = "iPhone 5s"
        case iPhoneSE = "iPhone SE"
        case iPhone6 = "iPhone 6"
        case iPhone6Plus = "iPhone 6 Plus"
        case iPhone6s = "iPhone 6s"
        case iPhone6sPlus = "iPhone 6s Plus"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
        case iPhone8 = "iPhone 8"
        case iPhone8Plus = "iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case iPhoneXR = "iPhone XR"
        case iPhoneXS = "iPhone XS"
        case iPhoneXSMax = "iPhone XS Max"
        case iPhone11 = "iPhone 11"
        case iPhone11Pro = "iPhone 11 Pro"
        case iPhone11ProMax = "iPhone 11 Pro Max"
        case iPhoneSE2 = "iPhone SE 2"
        case iPhone12Mini = "iPhone 12 mini"
        case iPhone12 = "iPhone 12"
        case iPhone12Pro = "iPhone 12 Pro"
        case iPhone12ProMax = "iPhone 12 Pro Max"
        case iPhone13Mini = "iPhone 13 mini"
        case iPhone13 = "iPhone 13 Pro"
        case iPhone13Pro = "iPhone 13 Pro Max"
        case iPhone13ProMax = "iPhone 13"
        case iPHoneSE3 = "iPhone SE 3"
        case iPhone14 = "iPhone 14"
        case iPhone14Plus = "iPhone 14 Plus"
        case iPhone14Pro = "iPhone 14 Pro"
        case iPhone14ProMax = "iPhone 14 Pro Max"
        case iPad2 = "iPad 2"
        case iPad3 = "iPad 3"
        case iPad4 = "iPad 4"
        case iPadAir = "iPad Air"
        case iPadAir2 = "iPad Air 2"
        case iPadMini = "iPad Mini"
        case iPadMini2 = "iPad Mini 2"
        case iPadMini3 = "iPad Mini 3"
        case iPadMini4 = "iPad Mini 4"
        case iPadMini5 = "iPad Mini 5"
        case iPadMini6 = "iPad Mini 6"
        case iPadPro = "iPad Pro"
        case appleTV = "Apple TV"
        case simulator = "Simulator"
        case undefined = "undefined"
        
        public init?(modelName: String) {
            switch modelName {
            case "iPod7,1": self = .iPodTouch6
            case "iPod9,1": self = .iPodTouch7
            case "iPhone3,1", "iPhone3,2", "iPhone3,3": self = .iPhone4
            case "iPhone4,1": self = .iPhone4s
            case "iPhone5,1", "iPhone5,2": self = .iPhone5
            case "iPhone5,3", "iPhone5,4": self = .iPhone5c
            case "iPhone6,1", "iPhone6,2": self = .iPhone5s
            case "iPhone8,4": self = .iPhoneSE
            case "iPhone7,2": self = .iPhone6
            case "iPhone7,1": self = .iPhone6Plus
            case "iPhone8,1": self = .iPhone6s
            case "iPhone8,2": self = .iPhone6sPlus
            case "iPhone9,1", "iPhone9,3": self = .iPhone7
            case "iPhone9,2", "iPhone9,4": self = .iPhone7Plus
            case "iPhone10,1", "iPhone10,4": self = .iPhone8
            case "iPhone10,2", "iPhone10,5": self = .iPhone8Plus
            case "iPhone10,3", "iPhone10,6": self = .iPhoneX
            case "iPhone11,8": self = .iPhoneXR
            case "iPhone11,2": self = .iPhoneXS
            case "iPhone11,6", "iPhone11,4": self = .iPhoneXSMax
            case "iPhone12,1": self = .iPhone11
            case "iPhone12,3": self = .iPhone11Pro
            case "iPhone12,5": self = .iPhone11ProMax
            case "iPhone12,8": self = .iPhoneSE2
            case "iPhone13,1": self = .iPhone12Mini
            case "iPhone13,2": self = .iPhone12
            case "iPhone13,3": self = .iPhone12Pro
            case "iPhone13,4": self = .iPhone12ProMax
            case "iPhone14,4": self = .iPhone13Mini
            case "iPhone14,5": self = .iPhone13
            case "iPhone14,2": self = .iPhone13Pro
            case "iPhone14,3": self = .iPhone13ProMax
            case "iPhone14,6": self = .iPHoneSE3
            case "iPhone14,7": self = .iPhone14
            case "iPhone14,8": self = .iPhone14Plus
            case "iPhone15,2": self = .iPhone14Pro
            case "iPhone15,3": self = .iPhone14ProMax
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": self = .iPad2
            case "iPad3,1", "iPad3,2", "iPad3,3": self = .iPad3
            case "iPad3,4", "iPad3,5", "iPad3,6": self = .iPad4
            case "iPad4,1", "iPad4,2", "iPad4,3": self = .iPadAir
            case "iPad5,3", "iPad5,4": self = .iPadAir2
            case "iPad2,5", "iPad2,6", "iPad2,7": self = .iPadMini
            case "iPad4,4", "iPad4,5", "iPad4,6": self = .iPadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9": self = .iPadMini3
            case "iPad5,1", "iPad5,2": self = .iPadMini4
            case "iPad11,1", "iPad11,2": self = .iPadMini5
            case "iPad14,1", "iPad14,2": self = .iPadMini6
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": self = .iPadPro
            case "AppleTV5,3": self = .appleTV
            case "i386", "x86_64", "arm64": self = .simulator
            default: self = .undefined
            }
            
            var iPads: [Generation] {
                return [.iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6, .iPadPro]
            }
            
            var iPhones: [Generation] {
                return [.iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE, .iPhoneSE2, .iPhone6, .iPhone6s, .iPhone6Plus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12Mini, .iPhone12, .iPhone12Pro, .iPhone12ProMax, .iPhone13Mini, .iPhone13, .iPhone13Pro, .iPhone13ProMax, .iPHoneSE3, .iPhone14, .iPhone14Pro, .iPhone14Plus, .iPhone14ProMax]
            }
            
            var lowResolutionDevices: [Generation] {
                return [.iPodTouch6, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE]
            }
            
            var isPad: Bool {
                return iPads.contains { $0 == self }
            }
            
            var isPhone: Bool {
                return iPhones.contains { $0 == self }
            }
            
            var isLowResolutionDevice: Bool {
                return lowResolutionDevices.contains { $0 == self }
            }
        }
    }
}
