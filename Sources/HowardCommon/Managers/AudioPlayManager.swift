//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import AVFoundation

public class AudioPlayManager: NSObject {
    public enum PlayMode {
        case playOneRepeatably
        case playOne
        case playAll
    }
    
    public enum Speed: Float, CaseIterable {
        case level0 = 0.5
        case level1 = 1.0
        case level2 = 1.5
        case level3 = 2.0
        case level4 = 2.5
    }
    
    
    private var playerItemStatusObservation: NSKeyValueObservation?
    private var playerPlayingStatusObservation: NSKeyValueObservation?
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var periodicTimeObserver: Any?
    private var endTime: CMTime? = CMTime(value: 0, timescale: 1000)
    private var startTime: CMTime? = CMTime(value: 0, timescale: 1000)
    
    private var isSeeking = false
    private(set) var playMode: PlayMode = .playAll
    public private(set) var speed = Speed.level1
    
    public weak var delegate: AudioPlayerManagerDelegate?
    
    deinit {
        playerPlayingStatusObservation = nil
        playerItemStatusObservation = nil
        periodicTimeObserver = nil
    }
    
    private func updateTimes(startAt: Int, endAt: Int) {
        self.startTime = CMTimeMake(value: Int64(startAt), timescale: 1000)
        self.endTime = CMTimeMake(value: Int64(endAt), timescale: 1000)
    }
    
    private func addIsPlayingObservationToPlayer(_ player: AVPlayer) {
        playerPlayingStatusObservation = player.observe(\.rate) { [weak self] player, value in
            guard let self = self else { return }
            self.delegate?.playStatusChanged(isPlaying: (self.player?.rate ?? 0.0) != 0.0)
        }
    }
    
    private func addStatusObservationToPlayerItem(_ item:AVPlayerItem) {
        playerItemStatusObservation = item.observe(\.status) { [weak self] _, _ in
            guard let self = self else { return }
            switch self.player?.status {
            case .readyToPlay:
                Logger.debug("[PS] - ready to play")
            case .failed:
                Logger.debug("[PS] - fail")
            case .unknown:
                Logger.debug("[PS] - unknown")
            default:
                Logger.debug("[PS] - dafault")
                break
            }
        }
    }
    
    private func addDidPlayToEndTimeObservationToPlayerItem(_ item: AVPlayerItem) {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: OperationQueue.current) { [weak self] notification in
            guard let self = self else { return }
            self.delegate?.progressUpdated(1.0)
            self.stop()
        }
    }
    
    private func addPeriodicTimeObserver(toPlayer player: AVPlayer, playerItem: AVPlayerItem) {
        periodicTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: nil, using: { [weak self] _ in
            guard let self = self , self.isSeeking == false else { return }
            
            if let endTime = self.endTime,
               playerItem.currentTime() > endTime {
                if case .playOne = self.playMode {
                    self.stop()
                } else if case .playOneRepeatably = self.playMode, let startTime = self.startTime {
                    self.seek(startTime)
                }
            }
            
            let progress = (playerItem.currentTime().seconds / playerItem.duration.seconds)
            if progress.isNaN == false {
                if self.isPlaying() == true {
                    self.delegate?.progressUpdated(progress)
                }
            }
        })
    }
    
    public func seek(_ milliSecondtime: Int) {
        self.seek(CMTimeMake(value: Int64(milliSecondtime), timescale: 1000))
    }
    
    public func seek(_ time: CMTime) {
        isSeeking = true
        player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { finished in
            self.isSeeking = !finished
        }
    }
    
    public func setupPlayer(withURL url: URL) {
        self.clearPlayer()
        
        let playerItem = AVPlayerItem(url: url)
        playerItem.audioTimePitchAlgorithm = .timeDomain
        player = AVPlayer(playerItem:  playerItem)
        guard let player = player else { return }
        self.addIsPlayingObservationToPlayer(player)
        self.addStatusObservationToPlayerItem(playerItem)
        self.addDidPlayToEndTimeObservationToPlayerItem(playerItem)
        self.addPeriodicTimeObserver(toPlayer: player, playerItem: playerItem)
        
    }
    
    public func clearPlayer() {
        playerPlayingStatusObservation?.invalidate()
        playerPlayingStatusObservation = nil
        
        playerItemStatusObservation?.invalidate()
        playerItemStatusObservation = nil
        
        if let timeObservvation = periodicTimeObserver {
            player?.removeTimeObserver(timeObservvation)
        }
        periodicTimeObserver = nil
        
        playerItem = nil
        player = nil
    }
    
    public func setPosition(startAt: Int, endAt: Int, needToSeek: Bool = true) {
        self.updateTimes(startAt: startAt, endAt: endAt)
        
        if needToSeek {
            self.seek(startAt)
        }
    }
    
    public func play(startAt: Int? = nil) {
        if let startAt = startAt {
            self.seek(startAt)
        }
        
        player?.rate = speed.rawValue
        self.delegate?.playStatusChanged(isPlaying: true)
    }
    
    public func stop() {
        if player?.isPlaying == false {
            return
        }
        player?.pause()
        self.delegate?.playStatusChanged(isPlaying: false)
    }
    
    public func isPlaying() -> Bool {
        player?.isPlaying ?? false
    }
    
    public func updatePlayMode(_ mode: PlayMode) {
        self.playMode = mode
    }
    
    public func changeRate() -> Speed {
        self.speed = self.speed.next()
        self.player?.rate = self.speed.rawValue
        return self.speed
    }
    
    public func updateSpeed(_ speed: Speed) {
        self.speed = speed
    }
    
    public func activateAudioSession() {
        SoundCenter.shared.register(item: self, stopOthers: true)
    }
    
    public func deactivateAudioSession() {
        SoundCenter.shared.unRegister(item: self, options: .notifyOthersOnDeactivation)
    }
}

public protocol AudioPlayerManagerDelegate: NSObjectProtocol {
    func progressUpdated(_ progress: Double)
    func playStatusChanged(isPlaying: Bool)
}

extension AudioPlayManager: SubSoundCenterProtocol {
    public var currentCategory: AVAudioSession.Category {
        .playback
    }
    
    public var soundPriority: SoundCenterPriority {
        .play
    }
    
    public func stopIfNeeded() {
        self.stop()
    }
    
    public func getInstance() -> AnyObject {
        self
    }
}
