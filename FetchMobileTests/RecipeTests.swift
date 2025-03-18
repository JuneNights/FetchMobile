//
//  RecipeTests.swift
//  FetchMobileTests
//
//  Created by Junior Figuereo on 3/17/25.
//

import XCTest
@testable import FetchMobile

final class RecipeTests: XCTestCase {

    /// Test decoding valid JSON
        func testValidRecipeDecoding() throws {
            let json = """
            {
                "cuisine": "Malaysian",
                      "name": "Apam Balik",
                      "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                      "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                      "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                      "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                      "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            }
            """.data(using: .utf8)!
            
            let recipe = try JSONDecoder().decode(Recipe.self, from: json)
            
            XCTAssertEqual(recipe.id, UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8"))
            XCTAssertEqual(recipe.cuisine, "Malaysian")
            XCTAssertEqual(recipe.name, "Apam Balik")
            XCTAssertEqual(recipe.photoURLLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
            XCTAssertEqual(recipe.photoURLSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
            XCTAssertEqual(recipe.sourceURL, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
            XCTAssertEqual(recipe.youtubeURL, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        }

        /// Test decoding invalid JSON (missing required fields)
        func testInvalidRecipeDecoding_MissingFields() {
            let json = """
            {
                "cuisine": "British",
                      "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                      "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                      "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                      "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                      "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
            }
            """.data(using: .utf8)!
            
            XCTAssertThrowsError(try JSONDecoder().decode(Recipe.self, from: json)) { error in
                guard case let DecodingError.dataCorrupted(context) = error else {
                    return XCTFail("Expected dataCorrupted error, but got \(error)")
                }
                XCTAssertTrue(context.debugDescription.contains("Missing or empty"))
            }
        }
        
        /// Test decoding JSON with an invalid UUID
        func testInvalidRecipeDecoding_InvalidUUID() {
            let json = """
            {
                "cuisine": "Malaysian",
                      "name": "Apam Balik",
                      "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                      "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                      "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                      "uuid": "INVALID UUID",
                      "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            }
            """.data(using: .utf8)!
            
            XCTAssertThrowsError(try JSONDecoder().decode(Recipe.self, from: json)) { error in
                guard case let DecodingError.dataCorrupted(context) = error else {
                    return XCTFail("Expected dataCorrupted error, but got \(error)")
                }
                XCTAssertTrue(context.debugDescription.contains("Missing or invalid UUID field"))
            }
        }

        /// Test handling an empty recipe list
        func testEmptyRecipeList() throws {
            let json = """
            {
                "recipes": []
            }
            """.data(using: .utf8)!

            let recipeList = try JSONDecoder().decode(RecipeResponse.self, from: json)
            XCTAssertTrue(recipeList.recipes.isEmpty)
        }

}
