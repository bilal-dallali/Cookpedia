//
//  RecipeCardUpdateView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/12/2024.
//

import SwiftUI
import SwiftData

struct RecipeCardUpdateView: View {
    
    let recipe: RecipeTitleCover
    var apiGetManager = APIGetRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @State private var isUpdateRecipeSelected: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipe.recipeCoverPictureUrl1).jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: geometry.size.width, height: 260)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("Greyscale400"))
                        .frame(width: geometry.size.width, height: 260)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button {
                            isUpdateRecipeSelected = true
                        } label: {
                            Circle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(width: 36, height: 36)
                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                .overlay {
                                    Image("Edit - Curved - Bold")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color("MyWhite"))
                                }
                        }
                        .padding(.top, 12)
                        .padding(.trailing, 12)
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 0)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0), Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0.5), Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.8), Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 1), Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 1)]), startPoint: .top, endPoint: .bottom))
                        .frame(height: 140)
                        .overlay(alignment: .bottomLeading) {
                            Text(recipe.title)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 18))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .padding(.horizontal, 12)
                                .padding(.bottom, 10)
                        }
                }
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color("Dark3"), lineWidth: 1)
            }
            .fullScreenCover(isPresented: $isUpdateRecipeSelected) {
                CreateRecipeView(isCreateRecipeSelected: $isUpdateRecipeSelected, isUpdateRecipeSelected: $isUpdateRecipeSelected, mode: .edit(existingRecipe: recipe.id))
            }
        }
    }
}

#Preview {
    RecipeCardUpdateView(recipe: RecipeTitleCover(id: 1, title: "Vegetable Fruit Salad", recipeCoverPictureUrl1:  "recipe_cover_picture_url_1_20241206213130_CCD6CA1F-2E34-4D4F-8BCC-BB5723EA52AF"))
        .frame(width: 183)
}
