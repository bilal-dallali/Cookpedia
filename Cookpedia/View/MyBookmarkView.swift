//
//  MyBookmarkView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/12/2024.
//

import SwiftUI
import SwiftData

struct MyBookmarkView: View {
    
    @State private var recipes: [RecipeTitleCoverUser] = []
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                    ForEach(recipes, id: \.id) { recipe in
//                        ForEach(recipes, id: \.id) { recipe in
//                            Button {
//                                //WelcomeView()
//                                //print("recipe id: \(recipe.id)")
//                            } label: {
//                                RecipeCardNameView(recipe: recipe)
//                                    .frame(height: 260)
//                            }
//                        }
//                    }
//                }
//                .padding(.top, 16)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(recipes, id: \.id) { recipe in
                        Button {
                            // Navigation logic for recipe details
                            print("recipe ID: \(recipe.id)")
                        } label: {
                            RecipeCardNameView(recipe: recipe)
                                .frame(height: 260)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 24)
        .ignoresSafeArea(edges: .bottom)
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("My Bookmark")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                        .padding(.leading, 16)
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //
                } label: {
                    Image("magnifying-glass-focused")
                        .resizable()
                        .frame(width: 28, height: 28)
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
            
//            apiGetManager.getSavedRecipes(userId: userId) { result in
//                switch result {
//                    case .success(let recipesData):
//                        DispatchQueue.main.async {
//                            do {
//                                let jsonData = try JSONSerialization.data(withJSONObject: recipesData, options: [])
//                                let decodedRecipes = try JSONDecoder().decode([RecipeTitleCoverUser].self, from: jsonData)
//                                self.recipes = decodedRecipes
//                                print("Fetched recipes:", recipes)
//                            } catch {
//                                print("Error decoding saved recipes:", error.localizedDescription)
//                            }
//                        }
//                    case .failure(let error):
//                        print("Error fetching saved recipes:", error.localizedDescription)
//                }
//            }
//            apiGetManager.getSavedRecipes(userId: userId) { result in
//                switch result {
//                    case .success(let fetchedRecipes):
//                        DispatchQueue.main.async {
//                            self.recipes = fetchedRecipes
//                            print("Fetched recipes:", fetchedRecipes)
//                        }
//                    case .failure(let error):
//                        print("Error fetching saved recipes:", error.localizedDescription)
//                }
//            }
            apiGetManager.getSavedRecipes(userId: userId) { result in
                switch result {
                    case .success(let fetchedRecipes):
                        DispatchQueue.main.async {
                            // Update only with the fetched saved recipes
                            self.recipes = fetchedRecipes
                            print("Fetched saved recipes:", self.recipes)
                        }
                    case .failure(let error):
                        print("Error fetching saved recipes:", error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    MyBookmarkView()
}
