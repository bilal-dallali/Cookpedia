//
//  RecipesData.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/25/24.
//

import Foundation

struct RecipeRegistration: Encodable {
    let userId: Int
    let title: String
    let recipeCoverPictureUrl1: String?
    let recipeCoverPictureUrl2: String?
    let description: String
    let cookTime: String
    let serves: String
    let origin: String
    let ingredients: [Ingredients]
    let instructions: [Instructions]
}

struct Ingredients: Encodable {
    let index: Int
    let ingredient: String
}

struct Instructions: Encodable {
    let index: Int
    let instruction: String
    let instructionPictureUrl1: String?
    let instructionPictureUrl2: String?
    let instructionPictureUrl3: String?
}
