//
//  CommentsData.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 01/01/2025.
//

import Foundation

struct CommentsPost: Codable {
    let userId: Int
    let recipeId: Int
    let comment: String
}

struct CommentsDetails: Codable {
    let id: Int
    let userId: Int
    let recipeId: Int
    let comment: String
    let fullName: String
    let profilePictureUrl: String
    let createdAt: String
    //let updatedAt: String
}
