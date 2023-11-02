//
//  VisionManager.swift
//
//
//  Created by howard on 11/2/23.
//

import Vision
import VisionKit

public class VisionManager: NSObject {
    public static let `default` = VisionManager()
    
    public func getText(withImage image: CGImage) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: Errors.ValidationError.nilValue("observations"))
                    return
                }
                
                let text = observations.compactMap({
                    $0.topCandidates(1).first?.string
                })
                
                continuation.resume(returning: text)
            }
            
            if #available(iOS 16.0, *) {
                let revision3 = VNRecognizeTextRequestRevision3
                request.revision = revision3
                request.recognitionLevel = .accurate
                request.recognitionLanguages =  ["ko-KR", "en-US"]
                request.usesLanguageCorrection = true
            } else {
                request.recognitionLanguages =  ["ko-KR", "en-US"]
                request.usesLanguageCorrection = true
            }
            
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

