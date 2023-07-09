//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import AVFoundation

@frozen public enum SoundCenterPriority: Int {
    case play
    case record
}

public protocol SubSoundCenterProtocol {
    var currentCategory: AVAudioSession.Category { get }
    var soundPriority: SoundCenterPriority { get }
    func stopIfNeeded()
    func getInstance() -> AnyObject
}

final public class SoundCenter {
    public static let shared = SoundCenter()
    
    private var playSubSoundCenters = [SubSoundCenterProtocol]()
    
    private var recordSubSoundCenters = [SubSoundCenterProtocol]()
    
    private func setCategory(_ category: AVAudioSession.Category) {
        do {
            try AVAudioSession.sharedInstance().setCategory(category, options: .mixWithOthers)
        } catch let error {
            Logger.error("setCategory \(error)", service: .soundCenter)
        }
    }
    
    private func stopOthers() {
        playSubSoundCenters.forEach { sub in
            sub.stopIfNeeded()
        }
    }
    
    public func register(item :SubSoundCenterProtocol, stopOthers: Bool = false) {
        if stopOthers == true {
            self.stopOthers()
        }
        
        if playSubSoundCenters.count == 0 &&
            recordSubSoundCenters.count == 0 {
            do {
                try AVAudioSession.sharedInstance().setActive(true, options: [])
                Logger.debug("setActive true", service: .soundCenter)
            } catch let error {
                Logger.error("register \(error)", service: .soundCenter)
                return
            }
        }
        
        switch item.soundPriority {
        case .play:
            playSubSoundCenters.append(item)
            if recordSubSoundCenters.count == 0 { // 녹음중이면 category변경을 하지 않는다.
                self.setCategory(item.currentCategory)
            }
        case .record:
            recordSubSoundCenters.append(item)
            self.setCategory(item.currentCategory)
        }
        
        Logger.debug("register: p:\(playSubSoundCenters), r:\(recordSubSoundCenters)", service: .soundCenter)
    }
    
    public func unRegister(item: SubSoundCenterProtocol, options: AVAudioSession.SetActiveOptions) {
        switch item.soundPriority {
        case .play:
            if let index = playSubSoundCenters.firstIndex(where: { sub in
                return sub.getInstance() === item.getInstance()
            }) {
                playSubSoundCenters.remove(at: index)
            }
        case .record:
            if let index = recordSubSoundCenters.firstIndex(where: { sub in
                return sub.getInstance() === item.getInstance()
            }) {
                recordSubSoundCenters.remove(at: index)
            } else {
                Logger.error("기존에 없던 record 인스턴스", service: .soundCenter)
            }
        }
        
        
        if playSubSoundCenters.count == 0 &&
            recordSubSoundCenters.count == 0 {
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: options)
                Logger.debug("setActive false", service: .soundCenter)
            } catch let error {
                Logger.error("deactivate \(error)", service: .soundCenter)
            }
        }
        
        Logger.debug("unRegister: p:\(playSubSoundCenters), r:\(recordSubSoundCenters)", service: .soundCenter)
    }
}
