//
//  RecipeListView.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

struct RecipeListView: View {
    @ObservedObject var recipeVM: RecipeViewModel
    @State private var selectedRecipe: Recipe?
    @Binding var selectedSort: RecipeSorting
    @State private var searchText: String = ""
    
    var filteredRecipes: [Recipe] {
            if searchText.isEmpty {
                return recipeVM.recipes
            } else {
                return recipeVM.recipes.filter { recipe in
                    recipe.name.localizedCaseInsensitiveContains(searchText) ||
                    recipe.cuisine.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Menu {
                    ForEach(RecipeSorting.allCases, id: \.self) { option in
                        Button(action: {
                            selectedSort = option
                            UserDefaultsSingleton.shared.setDefaults(value: option.displayName, key: "sortOption")
                        }) {
                            HStack {
                                Text(option.displayName)
                                Spacer()
                                if option == selectedSort {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.horizontal)
            
            TextField("Search recipes...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    Color.clear.frame(height: 1).id("top")
                    ForEach(filteredRecipes.sorted(by: getSortComparator(for: selectedSort))) { recipe in
                        HStack {
                            Button(action: { selectedRecipe = recipe }) {
                                RecipeRowView(recipe: recipe)
                            }
                            Spacer()
                        }
                        .sheet(item: $selectedRecipe) { recipe in
                            RecipeDetailView(recipe: recipe)
                        }
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    withAnimation {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

extension RecipeListView {
    // Helper function for sorting logic
    private func getSortComparator(for option: RecipeSorting) -> (Recipe, Recipe) -> Bool {
        switch option {
        case .name:
            return { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cuisine:
            return { $0.cuisine < $1.cuisine }
        }
    }
}
