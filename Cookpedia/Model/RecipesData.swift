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
    let ingredients: String
    let instructions: String
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

struct RecipeTitleCover: Codable {
    let id: Int
    let title: String
    let recipeCoverPictureUrl1: String
}

struct RecipeTitleCoverUser: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let recipeCoverPictureUrl1: String
    let fullName: String
    let profilePictureUrl: String
}

struct RecipeDetails: Codable {
    let id: Int
    let userId: Int
    let title: String
    let recipeCoverPictureUrl1: String
    let recipeCoverPictureUrl2: String
    let description: String
    let cookTime: String
    let serves: String
    let origin: String
    let ingredients: [IngredientDetails]
    let instructions: [InstructionDetails]
    let fullName: String
    let profilePictureUrl: String
    let username: String
}

struct IngredientDetails: Codable {
    let index: Int
    let ingredient: String
}

struct InstructionDetails: Codable {
    let index: Int
    let instruction: String
    let instructionPictureUrl1: String?
    let instructionPictureUrl2: String?
    let instructionPictureUrl3: String?
}
