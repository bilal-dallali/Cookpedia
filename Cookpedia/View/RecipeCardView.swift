//
//  RecipeCardView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 12/12/2024.
//

import SwiftUI
import SwiftData

struct RecipeCardView: View {
    
    let recipe: RecipeConnectedUser
    @State private var isBookmarkSelected: Bool = false
    var apiPostManager = APIPostRequest()
    var apiGetManager = APIGetRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    
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
                            print("bookmark \(recipe.id)")
                            guard let currentUser = userSession.first else {
                                return
                            }
                            
                            guard let userId = Int(currentUser.userId) else {
                                return
                            }
                            print("userId \(userId)")
                            print("bookmark selected \(isBookmarkSelected)")
                            apiPostManager.toggleBookmark(userId: userId, recipeId: recipe.id, isBookmarked: isBookmarkSelected) { result in
                                switch result {
                                case .success:
                                    isBookmarkSelected.toggle()
                                case .failure:
                                    print("failure")
                                }
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(width: 36, height: 36)
                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                .overlay {
                                    Image(isBookmarkSelected ? "bookmark-selected" : "bookmark-unselected")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                        }
                        .padding(.top, 12)
                        .padding(.trailing, 12)
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 0)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0), Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0.5), Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.8), Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 1), Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 1)]), startPoint: .top, endPoint: .bottom))
                        .frame(height: 140)
                        .overlay {
                            VStack {
                                Spacer()
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
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color("Dark3"), lineWidth: 1)
            }
            .onAppear {
                
                guard let currentUser = userSession.first else {
                    return
                }
                
                guard let userId = Int(currentUser.userId) else {
                    return
                }
                
                apiGetManager.getBookmark(userId: userId, recipeId: recipe.id) { result in
                    switch result {
                    case .success(let jsonResult):
                        if jsonResult {
                            print("bref \(userId) \(recipe.id) \(jsonResult)")
                            isBookmarkSelected = true
                        }
                    case .failure(let error):
                        print("failure \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeCardView(recipe: RecipeConnectedUser(id: 1, title: "Vegetable Fruit SaladVegetable Fruit SaladVegetable Fruit Salad", recipeCoverPictureUrl1:  "recipe_cover_picture_url_1_20241206213130_CCD6CA1F-2E34-4D4F-8BCC-BB5723EA52AF"))
        .frame(width: 183)
}
