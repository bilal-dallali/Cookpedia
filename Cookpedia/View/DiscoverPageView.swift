//
//  DiscoverPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI

struct DiscoverPageView: View {
    
    @State private var errorMessage: String = ""
    @State private var displayErrorMessage: Bool = false
    @State private var shouldRefresh: Bool = false
    @State private var mostPopularRecipes: [RecipeTitleCoverUser] = []
    @State private var recommendationsRecipes: [RecipeTitleCoverUser] = []
    @State private var mostSearchedRecipes: [RecipeTitleCoverUser] = []
    @State private var recentRecipes: [RecipeTitleCoverUser] = []
    @State private var mostPopularUsers: [UserDetails] = []
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    if displayErrorMessage {
                        Text(errorMessage)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 24))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 120)
                    } else {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack(spacing: 16) {
                                Image("logo")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("Discover")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 24))
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            
                            VStack(alignment: .leading, spacing: 28) {
                                NavigationLink {
                                    SearchView()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image("Search - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color("Greyscale600"))
                                            .padding(.leading, 20)
                                        Text("Search for Recipes or Chef")
                                            .foregroundStyle(Color("Greyscale600"))
                                            .font(.custom("Urbanist-Regular", size: 16))
                                        Spacer()
                                    }
                                    .frame(height: 58)
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("Most Popular")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Spacer()
                                        NavigationLink {
                                            MostPopularRecipeView()
                                        } label: {
                                            Image("Arrow - Right - Regular - Light - Outline")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                    }
                                    ScrollView(.horizontal) {
                                        LazyHStack(spacing: 16) {
                                            ForEach(mostPopularRecipes.prefix(5), id: \.id) { recipe in
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
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("Top Chefs")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Spacer()
                                        NavigationLink {
                                            TopChefView()
                                        } label: {
                                            Image("Arrow - Right - Regular - Light - Outline")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                    }
                                    
                                    ScrollView(.horizontal) {
                                        LazyHStack(spacing: 16) {
                                            ForEach(mostPopularUsers.prefix(5), id: \.id) { user in
                                                NavigationLink {
                                                    ProfilePageView(userId: user.id)
                                                } label: {
                                                    TopChefSmallCardView(user: user)
                                                        .frame(width: 140, height: 200)
                                                }
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                }
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("Our Recommendations")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Spacer()
                                        NavigationLink {
                                            OurRecommendationsView()
                                        } label: {
                                            Image("Arrow - Right - Regular - Light - Outline")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                    }
                                    ScrollView(.horizontal) {
                                        LazyHStack(spacing: 16) {
                                            ForEach(recommendationsRecipes.prefix(5), id: \.id) { recipe in
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
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("Most Searches")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Spacer()
                                        NavigationLink {
                                            MostSearchedView()
                                        } label: {
                                            Image("Arrow - Right - Regular - Light - Outline")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                    }
                                    ScrollView(.horizontal) {
                                        LazyHStack(spacing: 16) {
                                            ForEach(mostSearchedRecipes.prefix(5), id: \.id) { recipe in
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
                                
                                VStack(spacing: 20) {
                                    HStack {
                                        Text("New Recipes")
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
                                            ForEach(recentRecipes.prefix(5), id: \.id) { recipe in
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
                }
                .scrollIndicators(.hidden)
                .padding(.top, 16)
                .padding(.horizontal, 24)
                .background(Color("Dark1"))
                
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                AnalyticsManager.shared.logEvent(name: "view_discover_page")
            }
            .task {
                do {
                    let mostPopularRecipesData = try await apiGetManager.getMostPopularRecipes()
                    let mostPopularUsersData = try await apiGetManager.getUsersByRecipeViews()
                    let recommendationsRecipesData = try await apiGetManager.getRecommendations()
                    let mostSearchedRecipesData = try await apiGetManager.getMostSearchesRecipes()
                    let recentRecipesData = try await apiGetManager.getAllRecentRecipes()

                    // Mise à jour de l'UI sur le thread principal
                    DispatchQueue.main.async {
                        mostPopularRecipes = mostPopularRecipesData
                        mostPopularUsers = mostPopularUsersData
                        recommendationsRecipes = recommendationsRecipesData
                        mostSearchedRecipes = mostSearchedRecipesData
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
        }
    }
}

#Preview {
    DiscoverPageView()
}
