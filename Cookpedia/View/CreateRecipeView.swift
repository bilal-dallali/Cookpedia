//
//  CreateRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/11/2024.
//

import SwiftUI
import Foundation
import SwiftData

func decodeJwt(from jwt: String) -> [String: Any]? {
    let segments = jwt.components(separatedBy: ".")
    
    guard segments.count > 1 else {
        print("Invalid JWT format")
        return nil
    }
    
    var base64String = segments[1]
    
    // Ajouter des paddings si nécessaire
    let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
    let nbrPaddings = requiredLength - base64String.count
    if nbrPaddings > 0 {
        let padding = String().padding(toLength: nbrPaddings, withPad: "=", startingAt: 0)
        base64String = base64String.appending(padding)
    }
    base64String = base64String.replacingOccurrences(of: "-", with: "+")
    base64String = base64String.replacingOccurrences(of: "_", with: "/")
    
    guard let decodedData = Data(base64Encoded: base64String, options: []),
          let decodedString = String(data: decodedData, encoding: .utf8),
          let jsonData = decodedString.data(using: .utf8),
          let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
          let payload = json as? [String: Any] else {
        print("Failed to decode JWT payload")
        return nil
    }
    
    return payload
}

struct CreateRecipeView: View {
    
    @State var title = ""
    @State var description = ""
    @State var cookTime = ""
    @State var serves = ""
    @State var origin = ""
    @State var recipeCoverPictureUrl1: String = ""
    @State var recipeCoverPictureUrl2: String = ""
    
    @State private var selectedImage1: UIImage? = nil
    @State private var selectedImage2: UIImage? = nil
    @State private var isImagePickerPresented1: Bool = false
    @State private var isImagePickerPresented2: Bool = false
    @State private var isPublishedRecipe: Bool = false
    
    @State var ingredients: [String] = Array(repeating: "", count: 7)
    @State private var ingredientCounter: Int = 7
    @State private var ingredientDict: [Int: String] = [:]
    
    @State var instructions: [Instruction] = Array(repeating: Instruction(), count: 7)
    @State private var instructionCounter: Int = 7
    
    struct Instruction: Identifiable {
        let id = UUID()
        var text: String = ""
        var images: [UIImage] = []
        var instructionPictureUrl1: String? = nil
        var instructionPictureUrl2: String? = nil
        var instructionPictureUrl3: String? = nil
    }
    
    @Binding var isCreateRecipeSelected: Bool
    @FocusState private var isOriginFocused: Bool
    @State private var fieldsNotFilled: Bool = false
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.authToken) var userSession: [UserSession]
    @State var userId: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        HStack(spacing: 16) {
                            Button {
                                isCreateRecipeSelected = false
                            } label: {
                                Image("mark")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            Text("Create Recipe")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        Spacer()
                        HStack(spacing: 12) {
                            if recipeCoverPictureUrl1 != "" && title != "" && description != "" && cookTime != "" && serves != "" && origin != "" && ingredients.count > 0 && ingredients[0] != "" && instructions.count > 0 && instructions[0].text != "" {
                                Button {
                                    for user in userSession {
                                        print("user token : \(user.authToken)")
                                        
                                        if let decodedPayload = decodeJwt(from: user.authToken),
                                           let id = decodedPayload["id"] as? Int {
                                            print("User ID: \(id)")
                                            userId = id
                                        } else {
                                            print("Failed to decode JWT or extract user ID")
                                        }
                                    }
                                    
                                    let ingredientsJSON = ingredients.enumerated().map { index, ingredient in
                                        Ingredients(index: index + 1, ingredient: ingredient)
                                    }
                                    
                                    let instructionsJSON = instructions.enumerated().map { index, instruction in
                                        Instructions(
                                            index: index + 1,
                                            instruction: instruction.text,
                                            instructionPictureUrl1: instruction.instructionPictureUrl1,
                                            instructionPictureUrl2: instruction.instructionPictureUrl2,
                                            instructionPictureUrl3: instruction.instructionPictureUrl3
                                        )
                                    }
                                    
                                    let recipe = RecipeRegistration(userId: userId, title: title, recipeCoverPictureUrl1: recipeCoverPictureUrl1, recipeCoverPictureUrl2: recipeCoverPictureUrl2, description: description, cookTime: cookTime, serves: serves, origin: origin, ingredients: ingredientsJSON, instructions: instructionsJSON)
                                    
                                } label: {
                                    Text("Save")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Semibold", size: 16))
                                        .frame(width: 77, height: 38)
                                        .background(Color("Primary900"))
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                }
                                Button {
                                    //
                                } label: {
                                    Text("Publish")
                                        .foregroundStyle(Color("Primary900"))
                                        .font(.custom("Urbanist-Semibold", size: 16))
                                        .frame(width: 91, height: 38)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .strokeBorder(Color("Primary900"), lineWidth: 2)
                                        }
                                }
                            } else {
                                Button {
                                    
                                    fieldsNotFilled = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        fieldsNotFilled = false
                                    }
                                } label: {
                                    Text("Save")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Semibold", size: 16))
                                        .frame(width: 77, height: 38)
                                        .background(Color("Primary900"))
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                }
                                Button {
                                    fieldsNotFilled = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        fieldsNotFilled = false
                                    }
                                } label: {
                                    Text("Publish")
                                        .foregroundStyle(Color("Primary900"))
                                        .font(.custom("Urbanist-Semibold", size: 16))
                                        .frame(width: 91, height: 38)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .strokeBorder(Color("Primary900"), lineWidth: 2)
                                        }
                                }
                            }
                            Button {
                                //
                            } label: {
                                Image("more-circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    if fieldsNotFilled {
                        HStack(spacing: 6) {
                            Image("orange-alert")
                                .padding(.leading, 12)
                            Text("You must fill out all fields.")
                                .foregroundStyle(Color("MyOrange"))
                                .font(.custom("Urbanist-Regular", size: 12))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(Color("TransparentRed"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            Button {
                                isImagePickerPresented1 = true
                            } label: {
                                if let selectedImage1 = selectedImage1 {
                                    Image(uiImage: selectedImage1)
                                        .resizable()
                                        .frame(width: max(geometry.size.width - 48, 0), height: 382)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(alignment: .trailingLastTextBaseline) {
                                            Circle()
                                                .foregroundStyle(Color("Primary900"))
                                                .frame(width: 52, height: 52)
                                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                                .overlay {
                                                    Image("edit-white")
                                                        .resizable()
                                                        .frame(width: 28, height: 28)
                                                }
                                                .padding(12)
                                        }
                                } else {
                                    VStack(spacing: 32) {
                                        Image("image")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                        Text("Add recipe cover image")
                                            .foregroundStyle(Color("Greyscale500"))
                                            .font(.custom("Urbanist-Regular", size: 16))
                                    }
                                    .frame(width: max(geometry.size.width - 48, 0), height: 382)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    }
                                }
                            }
                            .sheet(isPresented: $isImagePickerPresented1) {
                                ImagePicker(image: $selectedImage1) { fileName in
                                    recipeCoverPictureUrl1 = "recipe_cover_1_\(fileName)"
                                }
                            }
                            Button {
                                isImagePickerPresented2 = true
                            } label: {
                                if let selectedImage2 = selectedImage2 {
                                    Image(uiImage: selectedImage2)
                                        .resizable()
                                        .frame(width: max(geometry.size.width - 48, 0), height: 382)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(alignment: .trailingLastTextBaseline) {
                                            Circle()
                                                .foregroundStyle(Color("Primary900"))
                                                .frame(width: 52, height: 52)
                                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                                .overlay {
                                                    Image("edit-white")
                                                        .resizable()
                                                        .frame(width: 28, height: 28)
                                                }
                                                .padding(12)
                                        }

                                } else {
                                    VStack(spacing: 32) {
                                        Image("image")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                        Text("Add recipe cover image")
                                            .foregroundStyle(Color("Greyscale500"))
                                            .font(.custom("Urbanist-Regular", size: 16))
                                    }
                                    .frame(width: max(geometry.size.width - 48, 0), height: 382)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    }
                                }
                            }
                            .sheet(isPresented: $isImagePickerPresented2) {
                                ImagePicker(image: $selectedImage2) { fileName in
                                    recipeCoverPictureUrl2 = "recipe_cover_2_\(fileName)"
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                        TextField("", text: $title)
                            .placeholder(when: title.isEmpty) {
                                Text("Recipe Title")
                                    .foregroundStyle(Color("Greyscale500"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                            }
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .padding(.leading, 20)
                            .frame(height: 58)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("Dark2"))
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                        CustomTextEditor(text: $description, backgroundColor: UIColor(named: "Dark2") ?? .gray, textColor: UIColor(named: "MyWhite") ?? .white, font: UIFont(name: "Urbanist-Semibold", size: 16) ?? .systemFont(ofSize: 16), textPadding: UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15))
                            .frame(height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                if description.isEmpty {
                                    VStack {
                                        HStack {
                                            Text("Lorem ipsum dolor sit amet ...")
                                                .foregroundStyle(Color("Greyscale500"))
                                                .font(.custom("Urbanist-Regular", size: 16))
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 18)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cook Time")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                        TextField("", text: $cookTime)
                            .placeholder(when: cookTime.isEmpty) {
                                Text("1 hour, 30 mins, etc")
                                    .foregroundStyle(Color("Greyscale500"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                            }
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .padding(.leading, 20)
                            .frame(height: 58)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("Dark2"))
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Serves")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                        TextField("", text: $serves)
                            .placeholder(when: serves.isEmpty) {
                                Text("3 people")
                                    .foregroundStyle(Color("Greyscale500"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                            }
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .padding(.leading, 20)
                            .frame(height: 58)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("Dark2"))
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Origin")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                        HStack(spacing: 12) {
                            TextField("", text: $origin)
                                .placeholder(when: origin.isEmpty) {
                                    Text("Location")
                                        .foregroundStyle(Color("Greyscale500"))
                                        .font(.custom("Urbanist-Regular", size: 16))
                                }
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .focused($isOriginFocused)
                            if isOriginFocused {
                                Image("location-focused")
                            } else {
                                Image("location-unfocused")
                            }
                        }
                        .frame(height: 58)
                        .padding(.horizontal, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("Dark2"))
                        }
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Ingredients:")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 24))
                        ForEach(ingredients.indices, id: \.self) { index in
                            IngredientSlotView(
                                ingredient: $ingredients[index],
                                index: index,
                                onDelete: {
                                    ingredients.remove(at: index)
                                }
                            )
                        }
                    }
                    
                    Button {
                        ingredients.append("")
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(Color("MyWhite"))
                            Text("Add Ingredients")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                        }
                        .frame(height: 58)
                        .frame(maxWidth: .infinity)
                        .background(Color("Dark4"))
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Instructions:")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 24))
                        InstructionListView(instructions: $instructions, instructionCounter: $ingredientCounter)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
            .background(Color("Dark1"))
//            .onAppear {
//                for user in userSession {
//                    print("user token : \(user.authToken)")
//                    
//                    if let decodedPayload = decodeJwt(from: user.authToken),
//                       let id = decodedPayload["id"] as? Int {
//                        print("User ID: \(id)")
//                        userId = String(id)
//                    } else {
//                        print("Failed to decode JWT or extract user ID")
//                    }
//                }
//            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set {
            guard let newValue = newValue, indices.contains(index) else { return }
            self[index] = newValue
        }
    }
}

#Preview {
    CreateRecipeView(isCreateRecipeSelected: .constant(true))
}
