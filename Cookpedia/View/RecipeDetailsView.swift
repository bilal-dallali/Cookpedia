//
//  RecipeDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 20/12/2024.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    @State private var recipeDetails: RecipeDetails
    let recipeId: Int
    var apiGetManager = APIGetRequest()
    
    // Private initializer for internal use only
    private init(recipeDetails: RecipeDetails, recipeId: Int) {
        self.recipeDetails = recipeDetails
        self.recipeId = recipeId
    }
    
    // Public initializer for NavigationLink and external use
    init(recipeId: Int) {
        self.recipeId = recipeId
        self.recipeDetails = RecipeDetails(
            id: recipeId,
            userId: 0,
            title: "Loading...",
            recipeCoverPictureUrl1: "",
            recipeCoverPictureUrl2: "",
            description: "",
            cookTime: "",
            serves: "",
            origin: "",
            ingredients: [],
            instructions: [],
            fullName: "",
            profilePictureUrl: "",
            username: ""
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl1).jpg")) { image in
                                    image
                                        .resizable()
                                        .frame(width: geometry.size.width, height: 430)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color("Greyscale400"))
                                        .frame(width: geometry.size.width, height: 430)
                                }
                                
                                AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl2).jpg")) { image in
                                    image
                                        .resizable()
                                        .frame(width: geometry.size.width, height: 430)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color("Greyscale400"))
                                        .frame(width: geometry.size.width, height: 430)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.paging)
                        
                
                    }
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .all)
            .background(Color("Dark1"))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 20) {
                        Button {
                            //
                        } label: {
                            Image("bookmark-unselected")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        Button {
                            //
                        } label: {
                            Image("send")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        Button {
                            //
                        } label: {
                            Image("more-circle")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                    }

                }
            }
            .onAppear {
                apiGetManager.getRecipeDetails(recipeId: recipeId) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let details):
                                self.recipeDetails = details
                            case .failure(let error):
                                print("error \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(recipeId: 1)
}
