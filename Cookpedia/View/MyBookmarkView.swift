//
//  MyBookmarkView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/12/2024.
//

import SwiftUI
import SwiftData

struct MyBookmarkView: View {
    
    @State private var savedRecipes: [SavedRecipe] = []
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(savedRecipes, id: \.id) { recipe in
                        VStack {
                            if let url = URL(string: "\(baseUrl)/\(recipe.recipeCoverPictureUrl1)") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            
                            Text(recipe.title)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text("By \(recipe.fullName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 16)
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
                    Image("magnifying-glass-focused")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
        }
        .onAppear {
            guard let currentUser = userSession.first else {
                return
            }
            
            guard let userId = Int(currentUser.userId) else {
                return
            }
            
            apiGetManager.getSavedRecipes(userId: userId) { result in
                switch result {
                    case .success(let recipesData):
                        DispatchQueue.main.async {
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: recipesData, options: [])
                                let decodedRecipes = try JSONDecoder().decode([SavedRecipe].self, from: jsonData)
                                self.savedRecipes = decodedRecipes
                                print("Fetched recipes:", savedRecipes)
                            } catch {
                                print("Error decoding saved recipes:", error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        print("Error fetching saved recipes:", error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    MyBookmarkView()
}
