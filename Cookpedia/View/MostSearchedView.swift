//
//  MostSearchedView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI

struct MostSearchedView: View {
    
    @State private var mostSearchedRecipes: [RecipeTitleCoverUser] = []
    @State private var shouldRefresh: Bool = false
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(mostSearchedRecipes, id: \.id) { recipe in
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
                    Text("Most Searches")
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
        }
    }
}

#Preview {
    MostSearchedView()
}
