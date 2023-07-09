//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import AVFoundation

public extension AVPlayer {
    var isPlaying: Bool {
        return self.rate > 0
    }
}
