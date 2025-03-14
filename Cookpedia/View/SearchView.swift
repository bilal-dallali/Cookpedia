//
//  SearchView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 08/03/2025.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText: String = ""
    @FocusState private var isTextFocused: Bool
    @State private var isRecipeSelected: Bool = true
    @State private var isPeopleSelected: Bool = false
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    @State private var mostSearchedRecipes: [RecipeTitleCoverUser] = []
    @State private var shouldRefresh: Bool = false
    @State private var mostPopularUsers: [UserDetails] = []
    
    var filteredResults: [Any] {
        if isRecipeSelected {
            return mostSearchedRecipes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        } else {
            return mostPopularUsers.filter { $0.fullName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                BackButtonView()
                HStack(spacing: 12) {
                    Image("Search - Regular - Light - Outline")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color("MyWhite"))
                        .padding(.leading, 20)
                    TextField("", text: $searchText)
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Semibold", size: 16))
                        .keyboardType(.default)
                        .multilineTextAlignment(.leading)
                        .frame(height: 22)
                        .frame(maxWidth: .infinity)
                        .focused($isTextFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            //
                        }
                    Button {
                        searchText = ""
                    } label: {
                        Image("Icon=times, Component=Additional Icons")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color("MyWhite"))
                    }
                    .padding(.trailing, 20)
                }
                .frame(height: 58)
                .frame(maxWidth: .infinity)
                .background(Color("Dark2"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isTextFocused ? Color("Primary900") : Color.clear, lineWidth: 2)
                }
            }
            HStack(spacing: 12) {
                Button {
                    isRecipeSelected = true
                    isPeopleSelected = false
                } label: {
                    if isRecipeSelected {
                        Text("Recipes")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    } else {
                        Text("Recipes")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Primary900"), lineWidth: 2)
                            }
                    }
                }
                
                Button {
                    isRecipeSelected = false
                    isPeopleSelected = true
                } label: {
                    if isPeopleSelected {
                        Text("People")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    } else {
                        Text("People")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Primary900"), lineWidth: 2)
                            }
                    }
                }
            }
            if isRecipeSelected {
                ScrollView {
                    if searchText != "" {
                        if filteredResults.isEmpty {
                            VStack(spacing: 60) {
                                Image("not-found-icon")
                                    .resizable()
                                    .frame(width: 350, height: 258)
                                VStack(spacing: 12) {
                                    Text("Not Found")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Text("We're sorry, the keyword you were looking for could not be found. Please search with another keywords.")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Regular", size: 18))
                                }
                            }
                            .padding(.vertical, 120)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(filteredResults as! [RecipeTitleCoverUser], id: \.id) { recipe in
                                    NavigationLink {
                                        RecipeDetailsView(recipeId: recipe.id, isSearch: false)
                                    } label: {
                                        RecipeCardNameView(recipe: recipe, shouldRefresh: $shouldRefresh)
                                            .frame(width: 183, height: 260)
                                    }
                                }
                            }
                        }
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(mostSearchedRecipes, id: \.id) { recipe in
                                NavigationLink {
                                    RecipeDetailsView(recipeId: recipe.id, isSearch: true)
                                } label: {
                                    RecipeCardNameView(recipe: recipe, shouldRefresh: $shouldRefresh)
                                        .frame(width: 183, height: 260)
                                }
                                
                            }
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
            } else if isPeopleSelected {
                ScrollView {
                    if searchText != "" {
                        if filteredResults.isEmpty {
                            VStack(spacing: 60) {
                                Image("not-found-icon")
                                    .resizable()
                                    .frame(width: 350, height: 258)
                                VStack(spacing: 12) {
                                    Text("Not Found")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Text("We're sorry, the keyword you were looking for could not be found. Please search with another keywords.")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Regular", size: 18))
                                }
                            }
                            .padding(.vertical, 120)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(filteredResults as! [UserDetails], id: \.id) { user in
                                    NavigationLink {
                                        ProfilePageView(userId: user.id)
                                    } label: {
                                        UserDetailsView(user: user)
                                    }
                                }
                            }
                        }
                    } else {
                        VStack(spacing: 20) {
                            ForEach(mostPopularUsers, id: \.id) { user in
                                NavigationLink {
                                    ProfilePageView(userId: user.id)
                                } label: {
                                    UserDetailsView(user: user)
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .background(Color("Dark1"))
        .onTapGesture {
            isTextFocused = false
        }
        .onAppear {
            isTextFocused = true
            
            Task {
                do {
                    let recipes = try await apiGetManager.getMostSearchesRecipes()
                    DispatchQueue.main.async {
                        self.mostSearchedRecipes = recipes
                    }
                } catch {
                    print("Failed to display most searched recipes")
                }
            }
            
            Task {
                do {
                    let users = try await apiGetManager.getUsersByRecipeViews()
                    DispatchQueue.main.async {
                        self.mostPopularUsers = users
                    }
                } catch {
                    print("Failed to load users by recipe views")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchView()
}
