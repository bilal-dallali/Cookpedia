//
//  YourFollowsRecipesView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 19/03/2025.
//

import SwiftUI
import SwiftData

struct YourFollowsRecipesView: View {
    
    @State private var errorMessage: String = ""
    @State private var displayErrorMessage: Bool = false
    @State private var recipes: [RecipeTitleCoverUser] = []
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
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
                        ForEach(recipes, id: \.id) { recipe in
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
                    Text("Your follows")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                        .padding(.leading, 16)
                    Spacer()
                }
            }
        }
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "view_your_follows_page")
        }
        .task {
            guard let currentUser = userSession.first else {
                return
            }
            
            let userId = currentUser.userId
            
            CrashManager.shared.setUserId(userId: String(userId))
            CrashManager.shared.addLog(message: "Display your follows")
            
            do {
                recipes = try await apiGetManager.getFollowedUsersRecipes(userId: userId)
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
    YourFollowsRecipesView()
}
