//
//  RecipeDetailView.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: URL(string: recipe.photoURLLarge))
                .frame(height: 250)
                .cornerRadius(12)
                .padding()
            
            Text(recipe.name)
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            Text("Cuisine: \(recipe.cuisine)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if let sourceURL = recipe.sourceURL, let url = URL(string: sourceURL) {
                Link("View Full Recipe", destination: url)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            
            if let youtubeURL = recipe.youtubeURL, let url = URL(string: youtubeURL) {
                Link("Watch on YouTube", destination: url)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom)
            }
        }
        .padding()
    }
}
