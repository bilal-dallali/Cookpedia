//
//  RecentRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 19/12/2024.
//

import SwiftUI
import SwiftData

struct RecentRecipeView: View {
    
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
                            RecipeDetailsView(recipeId: recipe.id)
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
                    Text("Recent recipes")
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
            apiGetManager.getAllRecentRecipes { result in
                switch result {
                    case .success(let recipes):
                        DispatchQueue.main.async {
                            self.recipes = recipes
                        }
                    case .failure(let error):
                        print("Error fetching recipes:", error.localizedDescription)
                }
            }
        }
    }
}


#Preview {
    RecentRecipeView()
}
