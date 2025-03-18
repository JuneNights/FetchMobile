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

            if let errorMessage = recipeVM.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red.opacity(0.75))
                    .font(.largeTitle)
                Spacer()
            } else if recipeVM.recipes.isEmpty {
                Text("Recipe list is empty..")
                    .foregroundStyle(.red.opacity(0.75))
                    .font(.largeTitle)
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    List {
                        Color.clear.frame(height: 1).id("top") // Used for scrolling to top
                        ForEach(filteredRecipes.sorted(by: getSortComparator(for: selectedSort))) { recipe in
                            Button(action: { selectedRecipe = recipe }) {
                                RecipeRowView(recipe: recipe)
                            }
                            .sheet(item: $selectedRecipe) { recipe in
                                RecipeDetailView(recipe: recipe)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await recipeVM.clearData()
                        await recipeVM.fetchRecipes()
                    }
                    
                    if !filteredRecipes.isEmpty {
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
