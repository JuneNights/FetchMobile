//
//  FetchMobileApp.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

@main
struct FetchMobileApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum URLSource: String, CaseIterable, Identifiable {
    case recipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case missing = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .recipes: return "Recipes"
        case .malformed: return "Malformed"
        case .missing: return "Missing"
        }
    }
}

struct ContentView: View {
    @StateObject private var recipeVM: RecipeViewModel
    @State private var selectedSource: URLSource = .recipes
    @State private var isLoading: Bool = true
    @State private var progress: Double = 0.0
    @State private var progressText: String = "Loading..."
    @State private var sortBy: RecipeSorting = .name

    init() {
        _recipeVM = StateObject(wrappedValue: RecipeViewModel(urlString: URLSource.recipes.rawValue))
    }

    var body: some View {
        VStack {
            Picker("Select Source", selection: $selectedSource) {
                ForEach(URLSource.allCases) { source in
                    Text(source.displayName).tag(source)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedSource) { newSource in
                recipeVM.updateURL(newURL: newSource.rawValue)
                Task {
                    isLoading = true
                    await recipeVM.clearData()
                    await recipeVM.fetchRecipes()
                    isLoading = false
                }
            }

            if isLoading {
                ProgressAnimation(foreground: Color.black, background: Color.white, progressText: $progressText, progress: $progress)
            } else {
                RecipeListView(recipeVM: recipeVM, selectedSort: $sortBy)
            }
        }
        .task {
            isLoading = true
            progress = 0.0
            await recipeVM.clearData()
            sortBy = UserDefaultsSingleton.shared.getDefaults(key: "sortOption")?.convertToSortOption() ?? .name
            await recipeVM.fetchRecipes()
            progress = 100.0
            isLoading = false
        }
    }
}
