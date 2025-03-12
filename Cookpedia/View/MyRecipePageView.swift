//
//  MyRecipePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI
import SwiftData

struct MyRecipePageView: View {
    
    @State private var draftRecipes: [RecipeTitleCover] = []
    @State private var publishedRecipes: [RecipeTitleCover] = []
    
    @State private var isDraftSelected: Bool = true
    @State private var isPublishedSelected: Bool = false
    
    @State private var publishedRecipesCount: Int = 0
    @State private var draftRecipesCount: Int = 0
    
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
                                Image("Search - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Color("MyWhite"))
                            }
                            
                            Button {
                                //
                            } label: {
                                Image("More Circle - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Color("MyWhite"))
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
                                        Text("Draft (\(draftRecipesCount))")
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
                                        Text("Draft (\(draftRecipesCount))")
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
                                        Text("Published (\(publishedRecipesCount))")
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
                                        Text("Published (\(publishedRecipesCount))")
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
                                ForEach(draftRecipes, id: \.id) { recipe in
                                    NavigationLink {
                                        RecipeDetailsView(recipeId: recipe.id)
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
                                
                                let userId = currentUser.userId
                                
                                Task {
                                    do {
                                        let recipes = try await apiGetManager.getPublishedRecipesFromUserId(userId: userId, published: false)
                                        self.draftRecipes = recipes
                                    } catch {
                                        print("Error fatching recipes")
                                    }
                                }
                            }
                        } else if isPublishedSelected {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(publishedRecipes, id: \.id) { recipe in
                                    NavigationLink {
                                        RecipeDetailsView(recipeId: recipe.id)
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
                                
                                let userId = currentUser.userId
                                
                                Task {
                                    do {
                                        let recipes = try await apiGetManager.getPublishedRecipesFromUserId(userId: userId, published: true)
                                        self.publishedRecipes = recipes
                                    } catch {
                                        print("Error fatching recipes")
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
        .onAppear {
            guard let currentUser = userSession.first else {
                return
            }
            
            let userId = currentUser.userId
            
            apiGetManager.getPublishedRecipesCount(userId: userId) { result in
                switch result {
                    case .success(let count):
                        DispatchQueue.main.async {
                            self.publishedRecipesCount = count
                        }
                    case .failure(let error):
                        print("Error fetching published recipes count:", error.localizedDescription)
                }
            }
            
            apiGetManager.getDraftRecipesCount(userId: userId) { result in
                switch result {
                    case .success(let count):
                        DispatchQueue.main.async {
                            self.draftRecipesCount = count
                        }
                    case .failure(let error):
                        print("Error fetching published recipes count:", error.localizedDescription)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyRecipePageView()
}
