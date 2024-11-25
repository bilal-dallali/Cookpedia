//
//  RecipesData.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/25/24.
//

import Foundation

struct RecipeRegistration: Codable {
    let userId: Int
    let title: String
    let recipeCoverPictureUrl1: String?
    let recipeCoverPictureUrl2: String?
    let description: String
    let cookTime: String
    let serves: String
    let origin: String
    let ingredients: [[String: String]]
    let instructions: [[String: String]]
}
