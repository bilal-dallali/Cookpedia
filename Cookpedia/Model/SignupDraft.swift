//
//  SignupDraft.swift
//  Cookpedia
//
//  Shared form state for the multi-screen signup flow.
//

import UIKit

enum SignupCookingLevel: String {
    case novice = "Novice"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case professional = "Professional"
    case master = "Master"
}

struct SignupDraft {
    var country = ""
    var cookingLevel: SignupCookingLevel?
    var level: String { cookingLevel?.rawValue ?? "" }
    var fullName = ""
    var phoneNumber = ""
    var gender = ""
    var date = ""
    var city = ""
    var profilePictureUrl = ""
    var selectedImage: UIImage?
}
