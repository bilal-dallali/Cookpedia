//
//  MostPopularRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI

struct MostPopularRecipeView: View {
    
    @State private var errorMessage: String = ""
    @State private var displayErrorMessage: Bool = false
    @State private var mostPopularRecipes: [RecipeTitleCoverUser] = []
    var apiGetManager = APIGetRequest()
    @State private var shouldRefresh: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                if displayErrorMessage {
                    Text(errorMessage)
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 120)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                        ForEach(mostPopularRecipes, id: \.id) { recipe in
                            NavigationLink {
                                RecipeDetailsView(recipeId: recipe.id, isSearch: false)
                            } label: {
                                RecipeCardNameView(recipe: recipe, shouldRefresh: $shouldRefresh)
                                    .frame(height: 260)
                            }
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
                    Text("Most Popular")
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
                    Image("Search - Regular - Light - Outline")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color("MyWhite"))
                }
            }
        }
        .task {
            do {
                mostPopularRecipes = try await apiGetManager.getMostPopularRecipes()
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
            } catch {
                errorMessage = "An unexpected error occurred. Please try again later."
                displayErrorMessage = true
            }
        }
    }
}

#Preview {
    MostPopularRecipeView()
}
