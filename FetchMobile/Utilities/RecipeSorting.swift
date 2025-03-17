//
//  RecipeSorting.swift
//  FetchMobile
//
//  Created by Junior Figuereo on 3/17/25.
//

import SwiftUI

class UserDefaultsSingleton {
    static var shared = UserDefaultsSingleton()
    private init() { }
    
    func setDefaults(value: String, key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func setDefaults(value: Int, key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func setDefaults(value: Bool, key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getDefaults(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func getDefaults(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func getDefaults(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}

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
