//
//  MostPopularRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI

struct MostPopularRecipeView: View {
    
    @State private var mostPopularRecipes: [RecipeTitleCoverUser] = []
    var apiGetManager = APIGetRequest()
    @State private var shouldRefresh: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(mostPopularRecipes, id: \.id) { recipe in
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
        .onAppear {
            apiGetManager.getMostPopularRecipes { result in
                switch result {
                    case .success(let recipes):
                        self.mostPopularRecipes = recipes
                    case .failure(let failure):
                        print("failure \(failure)")
                }
            }
        }
    }
}

#Preview {
    MostPopularRecipeView()
}
