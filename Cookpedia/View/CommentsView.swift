//
//  CommentsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI

struct CommentsView: View {
    
    let recipeId: Int
    @State private var isTopSelected: Bool = true
    @State private var isNewestSelected: Bool = false
    @State private var isOldestSelected: Bool = false
    @State private var commentText: String = ""
    @State private var refreshComment: Bool = false
    @State private var comments: [CommentsDetails] = []
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    var apiDeleteManager = APIDeleteRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        isTopSelected = true
                        isNewestSelected = false
                        isOldestSelected = false
                    } label: {
                        if isTopSelected {
                            Text("Top")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        } else {
                            Text("Top")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                    }
                    
                    Button {
                        isTopSelected = false
                        isNewestSelected = true
                        isOldestSelected = false
                    } label: {
                        if isNewestSelected {
                            Text("Newest")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        } else {
                            Text("Newest")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                    }
                    
                    Button {
                        isTopSelected = false
                        isNewestSelected = false
                        isOldestSelected = true
                    } label: {
                        if isOldestSelected {
                            Text("Oldest")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        } else {
                            Text("Oldest")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                    }

                }
                .padding(.top, 0)
                if isTopSelected {
                    ScrollView {
                        Text("Top")
                    }
                    .scrollIndicators(.hidden)
                } else if isNewestSelected {
                    ScrollView {
                        Text("New")
                    }
                    .scrollIndicators(.hidden)
                } else if isOldestSelected {
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(comments, id: \.id) { comment in
                                CommentSlotView(comment: comment, refreshComment: $refreshComment)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 24)
                }
            }
            .padding(.horizontal, 24)
            VStack(spacing: 0) {
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color("Dark4"))
                    }
                VStack(spacing: 0) {
                    Text("test")
                }
                .frame(height: 118)
                .frame(maxWidth: .infinity)
                
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Comments (125)")
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
            apiGetManager.getCommentsOrderAsc(forRecipeId: recipeId) { result in
                switch result {
                    case .success(let comments):
                        self.comments = comments
                    case .failure(let error):
                        print("error \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    CommentsView(recipeId: 1)
}
