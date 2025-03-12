//
//  HomePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/10/2024.
//

import SwiftUI
import SwiftData

struct HomePageView: View {
    
    @Binding var isHomeSelected: Bool
    @Binding var isDiscoverSelected: Bool
    @Binding var isMyRecipeSelected: Bool
    @Binding var isMyProfileSelected: Bool
    
    @State private var recentRecipes: [RecipeTitleCoverUser] = []
    @State private var yourRecipes: [RecipeTitleCoverUser] = []
    @State private var bookmarkedRecipes: [RecipeTitleCoverUser] = []
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    @State private var shouldRefresh: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 16) {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("Cookpedia")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                            
                            Spacer()
                            
                            NavigationLink {
                                MyBookmarkView()
                            } label: {
                                Image("Bookmark - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Color("MyWhite"))
                            }
                        }
                        .padding(.vertical, 5)
                        
                        VStack(alignment: .leading, spacing: 28) {
                            ZStack {
                                Image("read-more")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                HStack {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Learn how to become a master chef right now!")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .lineSpacing(7)
//                                        Button {
//                                            //
//                                        } label: {
//                                            Text("Read more")
//                                                .foregroundStyle(Color("Primary900"))
//                                                .font(.custom("Urbanist-Semibold", size: 14))
//                                        }
//                                        .frame(width: 102, height: 32)
//                                        .background(Color("MyWhite"))
//                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                        
                                    }
                                    .frame(width: 220)
                                    .padding(.leading, 30)
                                    Spacer()
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Recent Recipes")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    NavigationLink {
                                        RecentRecipeView()
                                    } label: {
                                        Image("Arrow - Right - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        ForEach(recentRecipes.prefix(3), id: \.id) { recipe in
                                            NavigationLink {
                                                RecipeDetailsView(recipeId: recipe.id)
                                            } label: {
                                                RecipeCardNameView(recipe: recipe, shouldRefresh: $shouldRefresh)
                                                    .frame(width: 183, height: 260)
                                            }
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Your Recipes")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        isHomeSelected = false
                                        isDiscoverSelected = false
                                        isMyRecipeSelected = true
                                        isMyProfileSelected = false
                                    } label: {
                                        Image("Arrow - Right - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        ForEach(yourRecipes.prefix(3), id: \.id) { recipe in
                                            NavigationLink {
                                                RecipeDetailsView(recipeId: recipe.id)
                                            } label: {
                                                RecipeCardNameView(recipe: recipe, shouldRefresh: $shouldRefresh)
                                                    .frame(width: 183, height: 260)
                                            }
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Your Bookmark")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    NavigationLink {
                                        MyBookmarkView()
                                    } label: {
                                        Image("Arrow - Right - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        ForEach(bookmarkedRecipes.prefix(3), id: \.id) { recipe in
                                            NavigationLink {
                                                RecipeDetailsView(recipeId: recipe.id)
                                            } label: {
                                                RecipeCardNameView(recipe: recipe, shouldRefresh: $shouldRefresh)
                                                    .frame(width: 183, height: 260)
                                            }
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
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
            .onAppear {
                guard let currentUser = userSession.first else {
                    return
                }
                
                let userId = currentUser.userId
                
                apiGetManager.getAllRecentRecipes { result in
                    switch result {
                        case .success(let recipes):
                            DispatchQueue.main.async {
                                self.recentRecipes = recipes
                            }
                        case .failure(let error):
                            print("Error fetching recipes:", error.localizedDescription)
                    }
                }
                
                apiGetManager.getConnectedUserRecipesWithDetails(userId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let recipes):
                                self.yourRecipes = recipes
                            case .failure(let error):
                                print("Failed to fetch user recipes: \(error.localizedDescription)")
                        }
                    }
                }
                
                Task {
                    do {
                        let fetchedRecipes = try await apiGetManager.getSavedRecipes(userId: userId)
                        self.bookmarkedRecipes = fetchedRecipes
                    } catch {
                        print("Failed to fetch saved recipes")
                    }
                }
            }
            .onChange(of: shouldRefresh) {
                guard let currentUser = userSession.first else {
                    return
                }
            
                let userId = currentUser.userId
                
                apiGetManager.getAllRecentRecipes { result in
                    switch result {
                        case .success(let recipes):
                            DispatchQueue.main.async {
                                self.recentRecipes = recipes
                            }
                        case .failure(let error):
                            print("Error fetching recipes:", error.localizedDescription)
                    }
                }
                
                apiGetManager.getConnectedUserRecipesWithDetails(userId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let recipes):
                                self.yourRecipes = recipes
                            case .failure(let error):
                                print("Failed to fetch user recipes: \(error.localizedDescription)")
                        }
                    }
                }
                
                Task {
                    do {
                        let fetchedRecipes = try await apiGetManager.getSavedRecipes(userId: userId)
                        self.bookmarkedRecipes = fetchedRecipes
                    } catch {
                        print("Failed to fetch saved recipes")
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView(isHomeSelected: .constant(true), isDiscoverSelected: .constant(false), isMyRecipeSelected: .constant(false), isMyProfileSelected: .constant(false))
}
