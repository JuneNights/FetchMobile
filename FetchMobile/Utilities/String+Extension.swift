//
//  String+Extension.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

extension String {
    func convertToSortOption() -> RecipeSorting {
        if self == "Name" { return .name }
        else { return .cuisine }
    }
}
