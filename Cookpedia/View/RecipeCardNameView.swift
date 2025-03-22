//
//  RecipeCardNameView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 31/10/2024.
//

import SwiftUI
import SwiftData

struct RecipeCardNameView: View {
    
    let recipe: RecipeTitleCoverUser
    @State private var isBookmarkSelected: Bool = false
    var apiPostManager = APIPostRequest()
    var apiGetManager = APIGetRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @Binding var shouldRefresh: Bool
    
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
                            guard let currentUser = userSession.first else {
                                return
                            }
                            
                            let userId = currentUser.userId
                            
                            CrashManager.shared.setUserId(userId: String(userId))
                            CrashManager.shared.addLog(message: "toggle bookmark")
                            
                            Task {
                                do {
                                    try await apiPostManager.toggleBookmark(userId: userId, recipeId: recipe.id, isBookmarked: isBookmarkSelected)
                                    isBookmarkSelected.toggle()
                                    shouldRefresh.toggle()
                                } catch {
                                    print("Error bookmarking recipe")
                                }
                            }
                        } label: {
                            Circle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(width: 36, height: 36)
                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                .overlay {
                                    Image(isBookmarkSelected ? "Bookmark - Regular - Bold" : "Bookmark - Regular - Light - Outline")
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
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.title)
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 18))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                HStack(spacing: 6) {
                                    AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(recipe.profilePictureUrl).jpg")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .frame(width: 16, height: 16)
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color("MyTeal"))
                                            .frame(width: 16, height: 16)
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    }
                                    Text(recipe.fullName)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Semibold", size: 10))
                                }
                            }
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
            .onAppear {
                guard let currentUser = userSession.first else {
                    return
                }
                
                let userId = currentUser.userId
                
                CrashManager.shared.setUserId(userId: String(userId))
                CrashManager.shared.addLog(message: "Display bookmark")
                
                Task {
                    do {
                        let isBookmarked = try await apiGetManager.getBookmark(userId: userId, recipeId: recipe.id)
                        if isBookmarked {
                            isBookmarkSelected = true
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
            .onChange(of: shouldRefresh) {
                guard let currentUser = userSession.first else {
                    return
                }
                
                let userId = currentUser.userId
                
                CrashManager.shared.setUserId(userId: String(userId))
                CrashManager.shared.addLog(message: "Refresh bookmark")
                
                Task {
                    do {
                        let isBookmarked = try await apiGetManager.getBookmark(userId: userId, recipeId: recipe.id)
                        if isBookmarked {
                            isBookmarkSelected = true
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeCardNameView(recipe: RecipeTitleCoverUser(id: 1, userId: 1, title: "Couscous royal", recipeCoverPictureUrl1: "recipe_cover_picture_url_1_20241218184217_70BD8E36-8989-49E6-A64F-B4B724222552", fullName: "Bilal Dallali", profilePictureUrl: "profile_picture_20241206182148_6A019BB5-C982-4764-AE6F-3902F31C5CD5"), shouldRefresh: .constant(false))
        .frame(width: 183)
}
