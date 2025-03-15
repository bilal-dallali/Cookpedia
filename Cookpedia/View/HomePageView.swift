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
    
    @State private var errorMessage: String = ""
    @State private var displayErrorMessage: Bool = false
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
                                //                                RoundedRectangle(cornerRadius: 20)
                                //                                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [
                                //                                        Color(red: 0.96, green: 0.28, blue: 0.29),
                                //                                        Color(red: 1, green: 0.45, blue: 0.46)
                                //                                    ]), startPoint: .bottomTrailing, endPoint: .topLeading))
                                //                                    .frame(maxWidth: .infinity)
                                //                                    .frame(height: 160)
                                HStack {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Learn how to become a master chef right now!")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .lineSpacing(7)
                                        
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
                                    LazyHStack(spacing: 16) {
                                        ForEach(recentRecipes.prefix(3), id: \.id) { recipe in
                                            NavigationLink {
                                                RecipeDetailsView(recipeId: recipe.id, isSearch: false)
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
                                    LazyHStack(spacing: 16) {
                                        ForEach(yourRecipes.prefix(3), id: \.id) { recipe in
                                            NavigationLink {
                                                RecipeDetailsView(recipeId: recipe.id, isSearch: false)
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
                                    LazyHStack(spacing: 16) {
                                        ForEach(bookmarkedRecipes.prefix(3), id: \.id) { recipe in
                                            NavigationLink {
                                                RecipeDetailsView(recipeId: recipe.id, isSearch: false)
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
            .task {
                guard let currentUser = userSession.first else {
                    return
                }
                
                let userId = currentUser.userId
                
                do {
                    let yourRecipesData = try await apiGetManager.getConnectedUserRecipesWithDetails(userId: userId)
                    
                    DispatchQueue.main.async {
                        yourRecipes = yourRecipesData
                    }
                } catch {
                    print("Error fetching recipes:")
                }
                
                do {
                    let bookmarkedRecipesData = try await apiGetManager.getSavedRecipes(userId: userId)
                    DispatchQueue.main.async {
                        bookmarkedRecipes = bookmarkedRecipesData
                    }
                } catch {
                    print("Failed to fetch bookmarked recipes:")
                }
                
                do {
                    let recentRecipesData = try await apiGetManager.getAllRecentRecipes()
                    DispatchQueue.main.async {
                        recentRecipes = recentRecipesData
                    }
                } catch let error as APIGetError {
                    DispatchQueue.main.async {
                        switch error {
                        case .invalidUrl:
                            errorMessage = "The request URL is invalid. Please check your connection."
                        case .invalidResponse:
                            errorMessage = "Unexpected response from the server. Try again later."
                        case .decodingError:
                            errorMessage = "We couldn't process the data. Please update your app."
                        case .serverError:
                            errorMessage = "The server is currently unavailable. Try again later."
                        case .userNotFound:
                            errorMessage = "We couldn't find the user you're looking for."
                        }
                        displayErrorMessage = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        errorMessage = "An unexpected error occurred. Please try again later."
                        displayErrorMessage = true
                    }
                }
            }
            .onChange(of: shouldRefresh) {
                guard let currentUser = userSession.first else {
                    return
                }
                
                let userId = currentUser.userId
                
                Task {
                    async let bookmarkedRecipes = apiGetManager.getSavedRecipes(userId: userId)
                    
                    do {
                        self.bookmarkedRecipes = try await bookmarkedRecipes
                    } catch let error as APIGetError {
                        switch error {
                        case .invalidUrl:
                            errorMessage = "The request URL is invalid. Please check your connection."
                        case .invalidResponse:
                            errorMessage = "Unexpected response from the server. Try again later."
                        case .decodingError:
                            errorMessage = "We couldn't process the data. Please update your app."
                        case .serverError:
                            errorMessage = "The server is currently unavailable. Try again later."
                        case .userNotFound:
                            errorMessage = "We couldn't find the user you're looking for."
                        }
                        displayErrorMessage = true
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView(isHomeSelected: .constant(true), isDiscoverSelected: .constant(false), isMyRecipeSelected: .constant(false), isMyProfileSelected: .constant(false))
}
