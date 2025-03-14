//
//  MyBookmarkView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/12/2024.
//

import SwiftUI
import SwiftData

struct MyBookmarkView: View {
    
    @State private var recipes: [RecipeTitleCoverUser] = []
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    @State private var shouldRefresh: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
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
                    Text("My Bookmark")
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
        .onAppear {
            guard let currentUser = userSession.first else {
                return
            }
            
            let userId = currentUser.userId
            
            Task {
                do {
                    let fetchedRecipes = try await apiGetManager.getSavedRecipes(userId: userId)
                    self.recipes = fetchedRecipes
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
            
            Task {
                do {
                    let fetchedRecipes = try await apiGetManager.getSavedRecipes(userId: userId)
                    self.recipes = fetchedRecipes
                } catch {
                    print("Failed to fetch saved recipes")
                }
            }
        }
    }
}

#Preview {
    MyBookmarkView()
}
