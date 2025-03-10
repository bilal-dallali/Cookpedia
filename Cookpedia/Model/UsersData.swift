//
//  UsersData.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import Foundation

struct UserRegistration: Codable {
    let username: String
    let email: String
    let password: String
    let country: String
    let level: String
    let fullName: String
    let phoneNumber: String
    let gender: String
    let date: String
    let city: String
    let profilePictureUrl: String
}

struct User: Decodable {
    let id: Int
    let username: String
    let email: String
    let password: String
    let fullName: String
    let phoneNumber: String
    let gender: String
    let dateOfBirth: String
    let profilePictureUrl: String?
    let country: String
    let city: String
    let cookingLevel: String
    let description: String?
    let youtube: String?
    let facebook: String?
    let twitter: String?
    let instagram: String?
    let website: String?
    let createdAt: String
}

struct UserDetails: Decodable {
    let id: Int
    let username: String
    let fullName: String
    let profilePictureUrl: String?
}

struct EditUser: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let description: String?
    let youtube: String?
    let facebook: String?
    let twitter: String?
    let instagram: String?
    let website: String?
    let city: String
    let country: String
    let profilePictureUrl: String?
}
