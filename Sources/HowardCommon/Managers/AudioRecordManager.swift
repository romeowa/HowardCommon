//
//  File.swift
//  
//
//  Created by howard on 2023/07/09.
//

import Foundation
import AVFAudio

public enum AudioRecordStatus {
    case notInit
    case recording
    case pause
}

public class AudioRecordManager {
    public init() { }
    
    public var fileURL: URL?
    public var recordStatus = AudioRecordStatus.notInit {
        didSet {
            self.delegate?.recordStatusChanged(status: recordStatus)
            if recordStatus == .recording {
                runTimer()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private lazy var settings = {
        return [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
              AVSampleRateKey: 48000,
          AVEncoderBitRateKey: 128000,
        AVNumberOfChannelsKey: 1,
     AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    }()
    private var audioRecorder: AVAudioRecorder?
    private var recordingStatusObservation: NSKeyValueObservation?
    private var currentTimeObservation: NSKeyValueObservation?
    private var timer: Timer?
    
    public var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    
    public var currentTime: TimeInterval {
        audioRecorder?.currentTime ?? .zero
    }
    
    public weak var delegate: AudioRecordManagerDelegate?
    
    private func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.delegate?.currentTimeChanged(time: self?.audioRecorder?.currentTime)
        })
    }
    
    private func clearRecord() {
        recordingStatusObservation?.invalidate()
        recordingStatusObservation = nil
        
        currentTimeObservation?.invalidate()
        currentTimeObservation = nil
        
        timer?.invalidate()
        timer = nil
        
        audioRecorder = nil
    }
    
    public func record() throws {
        if audioRecorder?.isRecording == true {
            Logger.error("isRecording == true", service: .soundCenter)
            return
        }
        
        guard var filePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last else {
            fatalError("CachePath should not be nil")
        }
        
        SoundCenter.shared.register(item: self)
        
        filePath = filePath.appending(pathComponent: "vitorec_\(Date().toString(dateFormat: "yyyymmdd_hh:mm")).m4a")
        fileURL = URL(fileURLWithPath: filePath)
        audioRecorder = try AVAudioRecorder(url: fileURL!, settings: settings)
        audioRecorder?.record()
        self.recordStatus = .recording
    }
    
    public func stop() {
        audioRecorder?.stop()
        self.recordStatus = .notInit
        self.clearRecord()
        SoundCenter.shared.unRegister(item: self, options: .notifyOthersOnDeactivation)
    }
    
    public func pause(){
        audioRecorder?.pause()
        self.recordStatus = .pause
    }
    
    public func resume() {
        audioRecorder?.record()
        self.recordStatus = .recording
    }
    
    public func getRecordingTime() -> TimeInterval {
        self.audioRecorder?.currentTime ?? .zero
    }
}

public protocol AudioRecordManagerDelegate: NSObjectProtocol {
    func recordStatusChanged(status: AudioRecordStatus)
    func currentTimeChanged(time: TimeInterval?)
}


extension AudioRecordManager: SubSoundCenterProtocol {
    public var currentCategory: AVAudioSession.Category {
        return AVAudioSession.Category.record
    }
    
    public var soundPriority: SoundCenterPriority {
        return .record
    }
    
    public func stopIfNeeded() {
        //
    }
    
    public func getInstance() -> AnyObject {
        return self
    }
}
