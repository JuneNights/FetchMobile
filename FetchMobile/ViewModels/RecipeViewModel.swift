//
//  RecipeViewModel.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import Combine
import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? // Store error messages

    let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!

    func fetchRecipes() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(RecipeList.self, from: data)
            
            if decodedData.recipes.isEmpty {
                self.errorMessage = "No recipes found. Please check back later!"
            } else {
                self.recipes = decodedData.recipes
                self.errorMessage = nil
            }
        } catch {
            self.errorMessage = "Failed to load recipes. Please try again later."
        }
    }
}


struct RecipeList: Decodable {
    let recipes: [Recipe]
}
