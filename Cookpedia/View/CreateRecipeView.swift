//
//  CreateRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/11/2024.
//

import SwiftUI

struct CreateRecipeView: View {
    
    @State private var title = ""
    @State private var description = ""
    @State private var cookTime = ""
    @State private var serves = ""
    @State private var origin = ""
    @State private var ingredients: [String] = Array(repeating: "", count: 7)
    @State private var ingredientCounter: Int = 7
    @State private var ingredientDict: [Int: String] = [:]
    
    
    @Binding var isCreateRecipeSelected: Bool
    @FocusState private var isOriginFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
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
                        Button {
                            print("Ingredients to submit:", ingredientDict)
                            print("Ingredients to submit:", ingredients)
                        } label: {
                            Text("Save")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(width: 77, height: 38)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                        Button {
                            print("Ingredients to submit:", ingredientDict)
                            print("Ingredients to submit:", ingredients)
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
                        Button {
                            //
                        } label: {
                            Image("more-circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }

                    }
                }
                Button {
                    print("add image")
                } label: {
                    VStack(spacing: 32) {
                        Image("image")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Add recipe cover image")
                            .foregroundStyle(Color("Greyscale500"))
                            .font(.custom("Urbanist-Regular", size: 16))
                    }
                    .frame(height: 382)
                    .frame(maxWidth: .infinity)
                    .background(Color("Dark2"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                    }
                }
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
                    ForEach(0..<ingredientCounter, id: \.self) { index in
                        IngredientSlotView(ingredient: Binding(
                            get: { ingredients[safe: index] ?? "" },
                            set: { value in
                                ingredients[safe: index] = value
                                ingredientDict[index] = value
                            }),
                            index: index,
                            onDelete: {
                                if index < ingredients.count {
                                    ingredients.remove(at: index)
                                    ingredientCounter -= 1
                                    ingredientDict.removeValue(forKey: index)
                                }
                            }
                        )
                    }
                }
                
                Button {
                    withAnimation {
                        ingredients.append("")
                        ingredientCounter += 1
                    }
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
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
        }
        .background(Color("Dark1"))
        
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
