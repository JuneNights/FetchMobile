//
//  RecipeViewModel.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import Combine
import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes() async {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            DispatchQueue.main.async {
                self.recipes = decodedResponse.recipes
            }
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
}
