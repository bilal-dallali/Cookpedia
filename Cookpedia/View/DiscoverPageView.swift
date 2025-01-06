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
                            HStack(spacing: 12) {
                                Image("Search - Regular - Light - Outline")
                                    .foregroundStyle(Color(searchRecipeOrChefText.isEmpty ? "Greyscale600" : "MyWhite"))
                                    .frame(width: 20, height: 20)
                                    .padding(.leading, 20)
                                TextField(text: $searchRecipeOrChefText) {
                                    Text("Search for Recipes or Chef")
                                        .foregroundStyle(Color("Greyscale600"))
                                        .font(.custom("Urbanist-Regular", size: 16))
                                }
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .keyboardType(.default)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Regular", size: 18))
                                .padding(.trailing, 20)
                                .focused($isTextFocused)
                            }
                            .frame(height: 58)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Most Popular")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image("Arrow - Right - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                                ScrollView(.horizontal) {
                                    HStack(spacing: 0) {
                                        ForEach(mostPopularRecipes, id: \.id) { recipe in
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
            .onTapGesture {
                isTextFocused = false
            }
            .onAppear {
                apiGetManager.getMostPopularRecipes { result in
                    switch result {
                        case .success(let recipes):
                            print("success")
                            self.mostPopularRecipes = recipes
                        case .failure(let failure):
                            print("failure")
                    }
                }
            }
        }
    }
}

#Preview {
    DiscoverPageView()
}
