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
    let cuisine, name: String
    let photoURLLarge, photoURLSmall: String
    let sourceURL: String?
    let youtubeURL: String?
    
    var id: String { uuid }
    private let uuid: String

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
        self.cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine) ?? "Unknown Cuisine"
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unnamed Recipe"
        self.photoURLLarge = try container.decodeIfPresent(String.self, forKey: .photoURLLarge) ?? ""
        self.photoURLSmall = try container.decodeIfPresent(String.self, forKey: .photoURLSmall) ?? ""
        self.sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        self.youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid) ?? "Unknown UUID"
    }
}
