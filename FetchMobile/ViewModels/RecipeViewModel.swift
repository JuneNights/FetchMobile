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
    @Published var errorMessage: String?
    
    private var urlString: String // Store the selected URL
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func clearData() async {
        recipes.removeAll()
        errorMessage = nil
    }

    func updateURL(newURL: String) {
        self.urlString = newURL
    }

    func fetchRecipes() async {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(RecipeResponse.self, from: data)

            if decodedData.recipes.isEmpty {
                errorMessage = "No recipes found. Please check back later!"
            } else {
                recipes = decodedData.recipes
            }
        } catch {
            errorMessage = "Failed to load recipes due to malformed data."
        }
    }
}
