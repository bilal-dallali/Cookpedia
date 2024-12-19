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
    @State private var bookmarkedRecipes: [RecipeTitleCoverUser] = []
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 0) {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("Cookpedia")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .padding(.leading, 16)
                            Spacer()
                            
                            NavigationLink {
                                NotificationPageView()
                            } label: {
                                Image("notifications")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            .padding(.trailing, 20)
                            
                            NavigationLink {
                                MyBookmarkView()
                            } label: {
                                Image("bookmark-unselected")
                                    .resizable()
                                    .frame(width: 28, height: 28)
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
                                        Button {
                                            //
                                        } label: {
                                            Text("Read more")
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-Semibold", size: 14))
                                        }
                                        .frame(width: 102, height: 32)
                                        .background(Color("MyWhite"))
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                        
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
                                    Button {
                                        //
                                    } label: {
                                        Image("arrow-right")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        //RecipeCardNameView(title: "Original Italian Pizza Recipe for ...", avatarImage: "jane-cooper", image: "original-pizza", name: "Jane Cooper")
                                        //RecipeCardNameView(title: "Special Blueberry & Banana Sandw...", avatarImage: "rayford-chenail", image: "blueberry-banana-sandwich", name: "Rayford Chenail")
                                        //RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "pancakes", name: "Jean-Philippe Hubert")
                                        ForEach(recentRecipes.prefix(3), id: \.id) { recipe in
                                            Button {
                                                // Navigation logic for recipe details
                                                print("recipe ID: \(recipe.id)")
                                            } label: {
                                                RecipeCardNameView(recipe: recipe)
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
                                        Image("arrow-right")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        //RecipeCardNameView(title: "Vegetable & Fruit Vegetarian Recip...", avatarImage: "tanner-stafford", image: "vegetable-and-fruit", name: "Tanner Stafford")
                                        //RecipeCardNameView(title: "Delicious & Easy Mexican Taco Re...", avatarImage: "lauralee-quintero", image: "mexican-taco", name: "Lauralee Qintero")
                                        //RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "vegetable-salad", name: "Jean-Philippe Hubert")
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
                                        Image("arrow-right")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        //RecipeCardNameView(title: "Meat, Noodle and Seafood Recipes ...", avatarImage: "clinton-mcclure", image: "meat-noodles-recipe", name: "Clinton Mcclure")
                                        //RecipeCardNameView(title: "Scrambled Eggs & French Bread ...", avatarImage: "charolette-hanlin", image: "scrambled-eggs", name: "Charolette Hanlin")
                                        //RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "egg-salad", name: "Jean-Philippe Hubert")
                                        ForEach(bookmarkedRecipes.prefix(3), id: \.id) { recipe in
                                            Button {
                                                // Navigation logic for recipe details
                                                print("recipe ID: \(recipe.id)")
                                            } label: {
                                                RecipeCardNameView(recipe: recipe)
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
                
                guard let userId = Int(currentUser.userId) else {
                    return
                }
                
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
                
                apiGetManager.getSavedRecipes(userId: userId) { result in
                    switch result {
                        case .success(let fetchedRecipes):
                            DispatchQueue.main.async {
                                // Update only with the fetched saved recipes
                                self.bookmarkedRecipes = fetchedRecipes
                            }
                        case .failure(let error):
                            print("Error fetching saved recipes:", error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView(isHomeSelected: .constant(true), isDiscoverSelected: .constant(false), isMyRecipeSelected: .constant(false), isMyProfileSelected: .constant(false))
}
