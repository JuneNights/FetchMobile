//
//  ImageCacheSingleton.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

class ImageCacheSingleton {
    static let shared = ImageCacheSingleton()
    private init() {}

    private let cache = NSCache<NSURL, UIImage>()

    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
