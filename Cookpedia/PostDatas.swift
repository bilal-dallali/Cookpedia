//
//  PostDatas.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/04/2023.
//

import Foundation

var errorMessage = ""

class APIManager {
    
    func registerUser(username: String, email: String, password: String, country: String, level: String, salad: Bool, egg: Bool, soup: Bool, meat: Bool, chicken: Bool, seafood: Bool, burger: Bool, pizza: Bool, sushi: Bool, rice: Bool, bread: Bool, fruit: Bool, vegetarian: Bool, vegan: Bool, glutenFree: Bool, nutFree: Bool, dairyFree: Bool, lowCarb: Bool, peanutFree: Bool, keto: Bool, soyFree: Bool, rawFood: Bool, lowFat: Bool, halal: Bool, fullName: String, phoneNumber: String, gender: String, date: String, city: String, profilePictureUrl: String) {
        
        let urlString = "http://localhost:3000/api/users"
        guard let url = URL(string: urlString) else { return }
        
        let params: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "full_name": fullName,
            "phone_number": phoneNumber,
            "gender": gender,
            "date_of_birth": date,
            "profile_picture_url": profilePictureUrl,
            "country": country,
            "city": city,
            "salad": salad,
            "egg": egg,
            "soup": soup,
            "meat": meat,
            "chicken": chicken,
            "seafood": seafood,
            "burger": burger,
            "pizza": pizza,
            "sushi": sushi,
            "rice": rice,
            "bread": bread,
            "fruit": fruit,
            "vegetarian": vegetarian,
            "vegan": vegan,
            "gluten_free": glutenFree,
            "nut_free": nutFree,
            "dairy_free": dairyFree,
            "low_carb": lowCarb,
            "peanut_free": peanutFree,
            "keto": keto,
            "soy_free": soyFree,
            "raw_food": rawFood,
            "low_fat": lowFat,
            "halal": halal,
            "cooking_level": level,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch let error {
            print("bitch", error.localizedDescription)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    print("bone chance", result ?? "No result")
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 400 {
                print("Error: Email already exists.")
                errorMessage = "Your email is already registered"
            } else if httpResponse.statusCode == 402 {
                print("Phone number already exists")
                errorMessage = "Your phone number is already registered"
            } else if httpResponse.statusCode >= 400 {
                print("Error: Something went wrong.")
            }
        }
        task.resume()
    }
}
