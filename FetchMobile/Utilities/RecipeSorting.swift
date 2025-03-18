//
//  RecipeSorting.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

enum RecipeSorting: String, CaseIterable, Identifiable {
    case name
    case cuisine
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .name: return "Name"
        case .cuisine: return "Cuisine"
        }
    }
}
