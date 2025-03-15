//
//  OurRecommendationsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI

struct OurRecommendationsView: View {
    
    @State private var recommendationsRecipes: [RecipeTitleCoverUser] = []
    var apiGetManager = APIGetRequest()
    @State private var shouldRefresh: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(recommendationsRecipes, id: \.id) { recipe in
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
                    Text("Our Recommendations")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                        .padding(.leading, 16)
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let recipes = try await apiGetManager.getRecommendations()
                    DispatchQueue.main.async {
                        self.recommendationsRecipes = recipes
                    }
                } catch {
                    print("Failed to load recommendations")
                }
            }

        }
    }
}

#Preview {
    OurRecommendationsView()
}
