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
    let salad: Bool
    let egg: Bool
    let soup: Bool
    let meat: Bool
    let chicken: Bool
    let seafood: Bool
    let burger: Bool
    let pizza: Bool
    let sushi: Bool
    let rice: Bool
    let bread: Bool
    let fruit: Bool
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let nutFree: Bool
    let dairyFree: Bool
    let lowCarb: Bool
    let peanutFree: Bool
    let keto: Bool
    let soyFree: Bool
    let rawFood: Bool
    let lowFat: Bool
    let halal: Bool
    let fullName: String
    let phoneNumber: String
    let gender: String
    let date: String
    let city: String
    let profilePictureUrl: String
}
