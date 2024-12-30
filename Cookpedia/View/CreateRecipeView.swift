//
//  CreateRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/11/2024.
//

import SwiftUI
import Foundation
import SwiftData

struct CreateRecipeView: View {
    
    @State private var title = ""
    @State private var description = ""
    @State private var cookTime = ""
    @State private var serves = ""
    @State private var origin = ""
    @State private var recipeCoverPictureUrl1: String = ""
    @State private var recipeCoverPictureUrl2: String = ""
    
    @State private var selectedImage1: UIImage? = nil
    @State private var selectedImage2: UIImage? = nil
    @State private var isImagePickerPresented1: Bool = false
    @State private var isImagePickerPresented2: Bool = false
    @State private var isPublishedRecipe: Bool = false
    @State private var isSavedRecipe: Bool = false
    
    @Binding var isHomeSelected: Bool
    @Binding var isDiscoverSelected: Bool
    @Binding var isMyRecipeSelected: Bool
    @Binding var isMyProfileSelected: Bool
    @Binding var isDraftSelected: Bool
    @Binding var isPublishedSelected: Bool
    
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
        
        // Rename the instruction images files
        func getRenamedImages(instructionIndex: Int) -> [(UIImage, String)] {
            images.enumerated().compactMap { (imageIndex, image) in
                // Chech the picture resolution if > 0
                guard image.size.width > 0 && image.size.height > 0 else { return nil }
                let fileName = "instructionImage\(imageIndex + 1)Index\(instructionIndex + 1)"
                return (image, fileName)
            }
        }
    }
    
    @Binding var isCreateRecipeSelected: Bool
    @FocusState private var isOriginFocused: Bool
    @State private var fieldsNotFilled: Bool = false
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiPostManager = APIPostRequest()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            HStack(spacing: 16) {
                                Button {
                                    isCreateRecipeSelected = false
                                } label: {
                                    Image("Icon=times, Component=Additional Icons")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundStyle(Color("MyWhite"))
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
                                        let encoder = JSONEncoder()
                                        encoder.outputFormatting = .sortedKeys
                                        
                                        // Put ingredients in JSON
                                        guard let ingredientsData = try? encoder.encode(
                                            ingredients.enumerated().map { index, ingredient in
                                                Ingredients(index: index + 1, ingredient: ingredient)
                                            }
                                        ) else {
                                            return
                                        }
                                        
                                        let ingredientsJson = String(data: ingredientsData, encoding: .utf8) ?? ""
                                        
                                        // Put instruction JSON
                                        guard let instructionsData = try? encoder.encode(
                                            instructions.enumerated().map { index, instruction in
                                                Instructions(
                                                    index: index + 1,
                                                    instruction: instruction.text,
                                                    instructionPictureUrl1: instruction.instructionPictureUrl1,
                                                    instructionPictureUrl2: instruction.instructionPictureUrl2,
                                                    instructionPictureUrl3: instruction.instructionPictureUrl3
                                                )
                                            }
                                        ) else {
                                            return
                                        }
                                        let instructionsJson = String(data: instructionsData, encoding: .utf8) ?? ""
                                        
                                        var instructionImages: [(UIImage, String)] = []
                                        
                                        for (instructionIndex, instruction) in instructions.enumerated() {
                                            instructionImages.append(contentsOf: instruction.getRenamedImages(instructionIndex: instructionIndex))
                                        }
                                        
                                        guard let currentUser = userSession.first else {
                                            return
                                        }
                                        
                                        guard let userId = Int(currentUser.userId) else {
                                            return
                                        }
                                        
                                        let recipe = RecipeRegistration(userId: userId, title: title, recipeCoverPictureUrl1: recipeCoverPictureUrl1, recipeCoverPictureUrl2: recipeCoverPictureUrl2, description: description, cookTime: cookTime, serves: serves, origin: origin, ingredients: ingredientsJson, instructions: instructionsJson)
                                        
                                        apiPostManager.uploadRecipe(recipe: recipe, recipeCoverPicture1: selectedImage1, recipeCoverPicture2: selectedImage2, instructionImages: instructionImages, isPublished: false) { result in
                                            switch result {
                                            case .success:
                                                isSavedRecipe = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                    isSavedRecipe = false
                                                    isCreateRecipeSelected = false
                                                    isHomeSelected = false
                                                    isDiscoverSelected = false
                                                    isMyRecipeSelected = true
                                                    isMyProfileSelected = false
                                                }
                                            case .failure(let error):
                                                print("Error uploading recipe: \(error)")
                                            }
                                        }
                                        
                                    } label: {
                                        Text("Save")
                                            .foregroundStyle(Color("Primary900"))
                                            .font(.custom("Urbanist-Semibold", size: 16))
                                            .frame(width: 77, height: 38)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: .infinity)
                                                    .strokeBorder(Color("Primary900"), lineWidth: 2)
                                            }
                                    }
                                    Button {
                                        let encoder = JSONEncoder()
                                        encoder.outputFormatting = .sortedKeys
                                        
                                        // Put ingredients in JSON
                                        guard let ingredientsData = try? encoder.encode(
                                            ingredients.enumerated().map { index, ingredient in
                                                Ingredients(index: index + 1, ingredient: ingredient)
                                            }
                                        ) else {
                                            return
                                        }
                                        
                                        let ingredientsJson = String(data: ingredientsData, encoding: .utf8) ?? ""
                                        
                                        // Put instructions JSON
                                        guard let instructionsData = try? encoder.encode(
                                            instructions.enumerated().map { index, instruction in
                                                Instructions(
                                                    index: index + 1,
                                                    instruction: instruction.text,
                                                    instructionPictureUrl1: instruction.instructionPictureUrl1,
                                                    instructionPictureUrl2: instruction.instructionPictureUrl2,
                                                    instructionPictureUrl3: instruction.instructionPictureUrl3
                                                )
                                            }
                                        ) else {
                                            return
                                        }
                                        let instructionsJson = String(data: instructionsData, encoding: .utf8) ?? ""
                                        
                                        var instructionImages: [(UIImage, String)] = []
                                        
                                        for (instructionIndex, instruction) in instructions.enumerated() {
                                            instructionImages.append(contentsOf: instruction.getRenamedImages(instructionIndex: instructionIndex))
                                        }
                                        
                                        guard let currentUser = userSession.first else {
                                            return
                                        }
                                        
                                        guard let userId = Int(currentUser.userId) else {
                                            return
                                        }
                                        
                                        let recipe = RecipeRegistration(userId: userId, title: title, recipeCoverPictureUrl1: recipeCoverPictureUrl1, recipeCoverPictureUrl2: recipeCoverPictureUrl2, description: description, cookTime: cookTime, serves: serves, origin: origin, ingredients: ingredientsJson, instructions: instructionsJson)
                                        
                                        
                                        apiPostManager.uploadRecipe(recipe: recipe, recipeCoverPicture1: selectedImage1, recipeCoverPicture2: selectedImage2, instructionImages: instructionImages, isPublished: true) { result in
                                            switch result {
                                            case .success:
                                                isPublishedRecipe = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                    isPublishedRecipe = false
                                                    isCreateRecipeSelected = false
                                                    isHomeSelected = false
                                                    isDiscoverSelected = false
                                                    isMyRecipeSelected = true
                                                    isMyProfileSelected = false
                                                }
                                            case .failure(let error):
                                                print("Error uploading recipe: \(error)")
                                            }
                                        }
                                        
                                    } label: {
                                        Text("Publish")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Semibold", size: 16))
                                            .frame(width: 91, height: 38)
                                            .background(Color("Primary900"))
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    }
                                } else {
                                    Button {
                                        fieldsNotFilled = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            fieldsNotFilled = false
                                        }
                                    } label: {
                                        Text("Save")
                                            .foregroundStyle(Color("Primary900"))
                                            .font(.custom("Urbanist-Semibold", size: 16))
                                            .frame(width: 77, height: 38)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: .infinity)
                                                    .strokeBorder(Color("Primary900"), lineWidth: 2)
                                            }
                                    }
                                    Button {
                                        fieldsNotFilled = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            fieldsNotFilled = false
                                        }
                                    } label: {
                                        Text("Publish")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Semibold", size: 16))
                                            .frame(width: 91, height: 38)
                                            .background(Color("Primary900"))
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    }
                                }
                                Button {
                                    //
                                } label: {
                                    Image("More Circle - Regular - Light - Outline")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color("MyWhite"))
                                }
                            }
                        }
                        if fieldsNotFilled {
                            HStack(spacing: 6) {
                                Image("Info Circle - Regular - Bold")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("MyOrange"))
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
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .frame(width: max(geometry.size.width - 48, 0), height: 382)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay(alignment: .trailingLastTextBaseline) {
                                                Circle()
                                                    .foregroundStyle(Color("Primary900"))
                                                    .frame(width: 52, height: 52)
                                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                                    .overlay {
                                                        Image("Edit - Curved - Bold")
                                                            .resizable()
                                                            .frame(width: 28, height: 28)
                                                            .foregroundStyle(Color("MyWhite"))
                                                    }
                                                    .padding(12)
                                            }
                                    } else {
                                        VStack(spacing: 32) {
                                            Image("Image - Regular - Bold")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .foregroundStyle(Color("Greyscale500"))
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
                                        recipeCoverPictureUrl1 = "recipe_cover_picture_url_1_\(fileName)"
                                    }
                                }
                                Button {
                                    isImagePickerPresented2 = true
                                } label: {
                                    if let selectedImage2 = selectedImage2 {
                                        Image(uiImage: selectedImage2)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .frame(width: max(geometry.size.width - 48, 0), height: 382)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay(alignment: .trailingLastTextBaseline) {
                                                Circle()
                                                    .foregroundStyle(Color("Primary900"))
                                                    .frame(width: 52, height: 52)
                                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                                    .overlay {
                                                        Image("Edit - Curved - Bold")
                                                            .resizable()
                                                            .frame(width: 28, height: 28)
                                                            .foregroundStyle(Color("MyWhite"))
                                                    }
                                                    .padding(12)
                                            }
                                        
                                    } else {
                                        VStack(spacing: 32) {
                                            Image("Image - Regular - Bold")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .foregroundStyle(Color("Greyscale500"))
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
                                        recipeCoverPictureUrl2 = "recipe_cover_picture_url_2_\(fileName)"
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
                            TextField(text: $title) {
                                Text("Recipe Title")
                                    .foregroundStyle(Color("Greyscale500"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    
                            }
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .frame(minHeight: 58)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                            VStack(alignment: .leading, spacing: 0) {
                                TextField(text: $description, axis: .vertical) {
                                    Text("Lorem ipsum dolor sit amet ...")
                                        .foregroundStyle(Color("Greyscale500"))
                                        .font(.custom("Urbanist-Regular", size: 16))
                                }
                                .keyboardType(.default)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 18)
                                Spacer()
                            }
                            .frame(minHeight: 140)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cook Time")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                            TextField(text: $cookTime) {
                                Text("1 hour, 30 mins, etc")
                                    .foregroundStyle(Color("Greyscale500"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    
                            }
                            .keyboardType(.numberPad)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .frame(minHeight: 58)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Serves")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                            TextField(text: $serves) {
                                Text("3 people")
                                    .foregroundStyle(Color("Greyscale500"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    
                            }
                            .keyboardType(.numberPad)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .frame(minHeight: 58)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Origin")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                            HStack {
                                TextField(text: $origin) {
                                    Text("Location")
                                        .foregroundStyle(Color("Greyscale500"))
                                        .font(.custom("Urbanist-Regular", size: 16))
                                        
                                }
                                .keyboardType(.default)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .padding(.vertical, 18)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                Image("Location - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color(origin.isEmpty ? "Greyscale500" : "MyWhite"))
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 58)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
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
                                Image("Icon=plus, Component=Additional Icons")
                                    .resizable()
                                    .frame(width: 20, height: 20)
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
                .background(Color(isSavedRecipe || isPublishedRecipe ? "BackgroundOpacity" : "Dark1"))
                .blur(radius: isSavedRecipe || isPublishedRecipe ? 4 : 0)
                .onTapGesture {
                    dismissKeyboard()
                }
            }
            if isSavedRecipe {
                ModalView(title: "Recipe Successfully saved", message: "Your recipe has been added to your draft, it is not yet published.")
            } else if isPublishedRecipe {
                ModalView(title: "Recipe Successfully published", message: "Your recipe has been published. Anyone can see it!")
            }
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
    CreateRecipeView(isHomeSelected: .constant(false), isDiscoverSelected: .constant(false), isMyRecipeSelected: .constant(true), isMyProfileSelected: .constant(false), isDraftSelected: .constant(false), isPublishedSelected: .constant(false), isCreateRecipeSelected: .constant(true))
}
