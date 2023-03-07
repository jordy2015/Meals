//
//  Meal.swift
//  soyfri
//
//  Created by Jordy Gonzalez on 3/6/23.
//

import Foundation

struct Meal: Decodable, Hashable {
    let id: String
    let name: String?
    let category: String?
    let area: String?
    let thumbUrl: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name  = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case thumbUrl = "strMealThumb"
        case youtubeUrl = "strYoutube"
    }
}
