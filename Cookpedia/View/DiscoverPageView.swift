//
//  DiscoverPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI

struct DiscoverPageView: View {
    
    @State private var searchRecipeOrChefText: String = ""
    @State private var shouldRefresh: Bool = false
    @FocusState private var isTextFocused: Bool
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
                                        .foregroundStyle(Color(searchRecipeOrChefText.isEmpty ? "Greyscale600" : "MyWhite"))
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
                                            }                                        }
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
                .scrollIndicators(.hidden)
                .padding(.top, 16)
                .padding(.horizontal, 24)
                .background(Color("Dark1"))
            }
            .navigationBarBackButtonHidden(true)
            .onTapGesture {
                isTextFocused = false
            }
            
            .onAppear {
                Task {
                    async let mostPopularRecipes = apiGetManager.getMostPopularRecipes()
                    async let mostPopularUsers = apiGetManager.getUsersByRecipeViews()
                    async let recommendationsRecipes = apiGetManager.getRecommendations()
                    async let mostSearchesRecipes = apiGetManager.getMostSearchesRecipes()
                    async let recentRecipes = apiGetManager.getAllRecentRecipes()
                    
                    do {
                        self.mostPopularRecipes = try await mostPopularRecipes
                        self.mostPopularUsers = try await mostPopularUsers
                        self.recommendationsRecipes = try await recommendationsRecipes
                        self.mostSearchedRecipes = try await mostSearchesRecipes
                        self.recentRecipes = try await recentRecipes
                    } catch {
                        print("Failed to load data")
                    }
                }
            }
        }
    }
}

#Preview {
    DiscoverPageView()
}
