//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation

public enum BuildCongriguration {
    public static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
