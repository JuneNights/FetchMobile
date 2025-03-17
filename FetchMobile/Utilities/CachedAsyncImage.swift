//
//  CachedAsyncImage.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }

        // Check cache first
        if let cachedImage = ImageCacheSingleton.shared.getImage(for: url) {
            image = cachedImage
            return
        }

        // Fetch from network
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                ImageCacheSingleton.shared.setImage(downloadedImage, for: url)
                DispatchQueue.main.async {
                    image = downloadedImage
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
