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

struct ContentView: View {
    @StateObject private var recipeVM: RecipeViewModel = .init()
    @State private var isLoading: Bool = true
    @State private var progress: Double = 0.0
    @State private var progressText: String = "Loading..."
    @State private var sortBy: RecipeSorting = .name
    var body: some View {
        Group {
            VStack {
                if isLoading {
                    ProgressAnimation(foreground: Color.black, background: Color.white, progressText: $progressText, progress: $progress)
                } else {
                    RecipeListView(recipeVM: recipeVM, selectedSort: $sortBy)
                }
            }
            .task {
                isLoading = true
                await recipeVM.fetchRecipes()
                sortBy = UserDefaultsSingleton.shared.getDefaults(key: "sortOption")?.convertToSortOption() ?? .name
                isLoading = false
            }
        }
    }
}
