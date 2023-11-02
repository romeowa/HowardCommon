//
//  PhotoViewfinderView.swift
//  TextExtractor
//
//  Created by howard on 10/31/23.
//

import SwiftUI

public struct PhotoViewfinderView: View {
    @Binding var image: Image?
    
    public init(image: Binding<Image?>) {
        _image = image
    }
    
    public var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    PhotoViewfinderView(image: .constant(Image(systemName: "pencil")))
}
