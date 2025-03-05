//
//  DataModel.swift
//  TextExtractor
//
//  Created by howard on 10/23/23.
//

import AVFoundation
import SwiftUI

public final class DataModel: NSObject, ObservableObject, @unchecked Sendable {
    public weak var delegate: DataModelDelegate?
    public let camera = Camera()
    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    
    @Published public var viewfinderImage: Image?
    @Published public var thumbnailImage: Image?
    
    var isPhotoLoaded = false
    
    public override init() {
        super.init()
        
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
        
        camera.delegate = self
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0.image }

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }

    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream.compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
            }
        }
    }
    
    public func savePhoto(imageData: Data) {
        Task {
            do {
                try await photoCollection.addImage(imageData)
                Logger.debug("Added image data to photo collection.")
            } catch {
                Logger.error("Failed to add image to photo collection: \(error.localizedDescription)")
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        
        guard let previewCGImage = photo.previewCGImageRepresentation(),
              let metadataOrientation = photo.metadata[String(kCGImagePropertyOrientation)] as? UInt32,
              let cgImageOrientation = CGImagePropertyOrientation(rawValue: metadataOrientation) else { return nil }
        
        guard let imageOrientation = Image.Orientation(rawValue: UInt8(cgImageOrientation.rawValue)) else { return nil }
        let thumbnailImage = Image(decorative: previewCGImage, scale: 1, orientation: imageOrientation)
        
        let photoDimensions = photo.resolvedSettings.photoDimensions
        let imageSize = (width: Int(photoDimensions.width), height: Int(photoDimensions.height))
        let previewDimensions = photo.resolvedSettings.previewDimensions
        let thumbnailSize = (width: Int(previewDimensions.width), height: Int(previewDimensions.height))
        
        return PhotoData(thumbnailImage: thumbnailImage, thumbnailSize: thumbnailSize, imageData: imageData, imageSize: imageSize)
    }
    
    public func loadPhotos() async {
        guard isPhotoLoaded == false else { return }
        
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else {
            Logger.error("Photo library access was not authorized.")
            return
        }
        
        Task {
            do {
                try await  self.photoCollection.load()
                await self.loadThumbnail()
            } catch {
                Logger.error("Failed to load photo collections: \(error.localizedDescription)")
            }
            
            self.isPhotoLoaded = true
        }
    }
    
    public func loadThumbnail(width: CGFloat = 256, height: CGFloat = 256) async {
        guard let asset = photoCollection.photoAssets.first else { return }
        await photoCollection.cache.requestImage(for: asset, targetSize: CGSize(width: width, height: height)) { result in
            if let result {
                Task { @MainActor in
                    self.thumbnailImage = result.image
                }
            }
        }
    }
}

extension DataModel: CameraDelegate {
    func didFinishProcessingPhoto(photoData: Data) {
        delegate?.didFinishProcessingPhoto(photoData: photoData)
    }
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var thumbnailSize: (width: Int, height: Int)
    var imageData: Data
    var imageSize: (width: Int, height: Int)
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

public protocol DataModelDelegate: NSObjectProtocol {
    func didFinishProcessingPhoto(photoData: Data)
}
