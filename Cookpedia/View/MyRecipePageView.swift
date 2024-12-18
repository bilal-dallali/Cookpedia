//
//  MyRecipePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI
import SwiftData

struct MyRecipePageView: View {
    
    @State private var recipes: [RecipeConnectedUser] = []
    
    @State private var isDraftSelected: Bool = true
    @State private var isPublishedSelected: Bool = false
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("My Recipes")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Button {
                                //
                            } label: {
                                Image("search-icon")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            
                            Button {
                                //
                            } label: {
                                Image("more-circle")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 28) {
                        HStack(spacing: 0) {
                            Button {
                                isDraftSelected = true
                                isPublishedSelected = false
                            } label: {
                                VStack(spacing: 12) {
                                    if isDraftSelected {
                                        Text("Draft (\(recipes.count))")
                                            .foregroundStyle(Color("Primary900"))
                                            .font(.custom("Urbanist-SemiBold", size: 18))
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .fill(Color("Primary900"))
                                                    .frame(height: 4)
                                                    .clipShape(.rect(cornerRadius: 100))
                                            }
                                    } else {
                                        Text("Draft (\(recipes.count))")
                                            .foregroundStyle(Color("Greyscale700"))
                                            .font(.custom("Urbanist-SemiBold", size: 18))
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .fill(Color("Dark4"))
                                                    .frame(height: 2)
                                                    .clipShape(.rect(cornerRadius: 100))
                                            }
                                    }
                                }
                            }
                            
                            Button {
                                isDraftSelected = false
                                isPublishedSelected = true
                            } label: {
                                VStack(spacing: 12) {
                                    if isPublishedSelected {
                                        Text("Published (\(recipes.count))")
                                            .foregroundStyle(Color("Primary900"))
                                            .font(.custom("Urbanist-SemiBold", size: 18))
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .fill(Color("Primary900"))
                                                    .frame(height: 4)
                                                    .clipShape(.rect(cornerRadius: 100))
                                            }
                                    } else {
                                        Text("Published (\(recipes.count))")
                                            .foregroundStyle(Color("Greyscale700"))
                                            .font(.custom("Urbanist-SemiBold", size: 18))
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .fill(Color("Dark4"))
                                                    .frame(height: 2)
                                                    .clipShape(.rect(cornerRadius: 100))
                                            }
                                    }
                                }
                            }
                            
                        }
                        .frame(height: 41)
                        .frame(maxWidth: .infinity)
                        
                        if isDraftSelected {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(recipes, id: \.id) { recipe in
                                    Button {
                                        //WelcomeView()
                                        print("recipe id: \(recipe.id)")
                                    } label: {
                                        RecipeCardUpdateView(recipe: recipe)
                                            .frame(height: 260)
                                    }
                                }
                            }
                            .onAppear {
                                guard let currentUser = userSession.first else {
                                    return
                                }
                                
                                guard let userId = Int(currentUser.userId) else {
                                    return
                                }
                                print("userId: \(userId)")
                                
                                apiGetManager.getConnectedPublishedUserRecipes(userId: userId, published: false) { result in
                                    switch result {
                                        case .success(let recipes):
                                            DispatchQueue.main.async {
                                                print("Published recipes:", recipes)
                                                self.recipes = recipes
                                            }
                                        case .failure(let error):
                                            DispatchQueue.main.async {
                                                print("Error fetching recipes:", error.localizedDescription)
                                            }
                                    }
                                }
                            }
                        } else if isPublishedSelected {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(recipes, id: \.id) { recipe in
                                    Button {
                                        //WelcomeView()
                                        print("recipe id: \(recipe.id)")
                                    } label: {
                                        RecipeCardUpdateView(recipe: recipe)
                                            .frame(height: 260)
                                    }
                                }
                            }
                            .onAppear {
                                guard let currentUser = userSession.first else {
                                    return
                                }
                                
                                guard let userId = Int(currentUser.userId) else {
                                    return
                                }
                                print("userId: \(userId)")
                                
                                apiGetManager.getConnectedPublishedUserRecipes(userId: userId, published: true) { result in
                                    switch result {
                                        case .success(let recipes):
                                            DispatchQueue.main.async {
                                                print("Published recipes:", recipes)
                                                self.recipes = recipes
                                            }
                                        case .failure(let error):
                                            DispatchQueue.main.async {
                                                print("Error fetching recipes:", error.localizedDescription)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 16)
            .padding(.horizontal, 24)
            .background(Color("Dark1"))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyRecipePageView()
}
