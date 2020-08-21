//
//  Restaurants.swift
//  MyRestaurants
//
//  Created by Leandro Prado on 2020-08-19.
//  Copyright © 2020 Leandro Prado. All rights reserved.
//

import Foundation

struct Restaurants: Decodable {
    let name: String
    let category: Category
    let cost: String
    
    enum Category: Decodable {
        case all
        case pizza
        case burgers
        case italian
        case mexican
        case asian
        case breakfast
        case brazilian
        case indian
        case lebanese
    }
}

extension Restaurants.Category: CaseIterable { }

extension Restaurants.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: String) {
        switch rawValue {
            case "All": self = .all
            case "Pizza": self = .pizza
            case "Burgers": self = .burgers
            case "Italian": self = .italian
            case "Mexican": self = .mexican
            case "Asian": self = .asian
            case "Breakfast": self = .breakfast
            case "Brazilian": self = .brazilian
            case "Indian": self = .indian
            case "Lebanese": self = .lebanese
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .all: return "All"
        case .pizza: return "Pizza"
        case .burgers: return "Burgers"
        case .italian: return "Italian"
        case .mexican: return "Mexican"
        case .asian: return "Asian"
        case .breakfast: return "Breakfast"
        case .brazilian: return "Brazilian"
        case .indian: return "Indian"
        case .lebanese: return "Lebanese"
        }
    }
}

extension Restaurants {
    static func restaurants() -> [Restaurants] {
        guard let url = Bundle.main.url(forResource: "restaurants", withExtension: "json"), let data = try? Data(contentsOf: url)
            else { return [] }
    
        do {
            return try JSONDecoder().decode([Restaurants].self, from: data)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
