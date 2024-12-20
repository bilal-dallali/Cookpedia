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
            id: recipeId, // Placeholder, replace with actual loading logic
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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl1).jpg")) { image in
                    image
                        .resizable()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                } placeholder: {
                    ProgressView()
                        .frame(width: 72, height: 72)
                }
                
                Text("\(recipeDetails.title)")
                
                AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(recipeDetails.profilePictureUrl).jpg")) { image in
                    image
                        .resizable()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                } placeholder: {
                    ProgressView()
                        .frame(width: 72, height: 72)
                }
                
                Text(recipeDetails.fullName)
                Text(recipeDetails.username)
                Text(recipeDetails.description)
                ForEach(recipeDetails.ingredients, id: \.index) { ingredient in
                    HStack {
                        Text("\(ingredient.index)")
                        Text("\(ingredient.ingredient)")
                    }
                }
                
                ForEach(recipeDetails.instructions, id: \.index) { instruction in
                    VStack {
                        HStack {
                            Text("\(instruction.index)")
                            Text("\(instruction.instruction)")
                        }
                        HStack {
                            AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl1 ?? "").jpg")) { image in
                                image
                                    .resizable()
                                    .frame(width: 72, height: 72)
                            } placeholder: {
                                Image("ellipse")
                                    .resizable()
                                    .frame(width: 72, height: 72)
                            }
                            
                            AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl2 ?? "").jpg")) { image in
                                image
                                    .resizable()
                                    .frame(width: 72, height: 72)
                            } placeholder: {
                                Image("ellipse")
                                    .resizable()
                                    .frame(width: 72, height: 72)
                            }
                            
                            AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl3 ?? "").jpg")) { image in
                                image
                                    .resizable()
                                    .frame(width: 72, height: 72)
                            } placeholder: {
                                Image("ellipse")
                                    .resizable()
                                    .frame(width: 72, height: 72)
                            }
                        }
                    }
                }

            }
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            apiGetManager.getRecipeDetails(recipeId: recipeId) { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let details):
                            print("ghjk")
                            self.recipeDetails = details
                            //self.isLoading = false
                            //self.recipeCoverPictureUrl1 = details.recipeCoverPictureUrl1
                        case .failure(let error):
                            print("error \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(recipeId: 1)
}
