//
//  RecipeModal.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Codable {
    let id: UUID
    let cuisine, name: String
    let photoURLLarge, photoURLSmall: String
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine), !cuisine.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .cuisine, in: container, debugDescription: "Missing or empty cuisine field")
        }
        guard let name = try container.decodeIfPresent(String.self, forKey: .name), !name.isEmpty else {
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Missing or empty name field")
        }
        guard let uuidString = try container.decodeIfPresent(String.self, forKey: .uuid), let uuid = UUID(uuidString: uuidString) else {
            throw DecodingError.dataCorruptedError(forKey: .uuid, in: container, debugDescription: "Missing or invalid UUID field")
        }
        
        self.photoURLLarge = try container.decodeIfPresent(String.self, forKey: .photoURLLarge) ?? ""
        self.photoURLSmall = try container.decodeIfPresent(String.self, forKey: .photoURLSmall) ?? ""
        self.sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        self.youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        
        self.id = uuid
        self.name = name
        self.cuisine = cuisine
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(cuisine, forKey: .cuisine)
        try container.encode(name, forKey: .name)
        try container.encode(id.uuidString, forKey: .uuid)
        try container.encode(photoURLLarge, forKey: .photoURLLarge)
        try container.encode(photoURLSmall, forKey: .photoURLSmall)
        try container.encodeIfPresent(sourceURL, forKey: .sourceURL)
        try container.encodeIfPresent(youtubeURL, forKey: .youtubeURL)
    }
}
