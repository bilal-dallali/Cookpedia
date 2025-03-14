//
//  FollowersPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/12/2024.
//

import SwiftUI

struct FollowersPageView: View {
    
    let userId: Int
    @State private var errorMessage: String = ""
    @State private var displayErrorMessage: Bool = false
    @State private var followingUser: [UserDetails] = []
    @State private var followerUser: [UserDetails] = []
    @State var isFollowingSelected: Bool
    @State var isFollowersSelected: Bool
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 12) {
                        Button {
                            isFollowingSelected = true
                            isFollowersSelected = false
                        } label: {
                            if isFollowingSelected {
                                Text("Following")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Semibold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                                    .background(Color("Primary900"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            } else {
                                Text("Following")
                                    .foregroundStyle(Color("Primary900"))
                                    .font(.custom("Urbanist-Semibold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                            }
                        }
                        
                        Button {
                            isFollowingSelected = false
                            isFollowersSelected = true
                        } label: {
                            if isFollowersSelected {
                                Text("Followers")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Semibold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                                    .background(Color("Primary900"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            } else {
                                Text("Followers")
                                    .foregroundStyle(Color("Primary900"))
                                    .font(.custom("Urbanist-Semibold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                            }
                        }
                    }
                    if isFollowingSelected {
                        if displayErrorMessage {
                            Text(errorMessage)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 120)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(followingUser, id: \.id) { user in
                                    NavigationLink {
                                        ProfilePageView(userId: user.id)
                                    } label: {
                                        UserDetailsView(user: user)
                                    }
                                }
                            }
                        }
                    } else if isFollowersSelected {
                        if displayErrorMessage {
                            Text(errorMessage)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 120)
                        } else {
                            VStack(spacing: 20) {
                                ForEach(followerUser, id: \.id) { user in
                                    NavigationLink {
                                        ProfilePageView(userId: user.id)
                                    } label: {
                                        UserDetailsView(user: user)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .background(Color("Dark1"))
            .task {
                do {
                    followerUser = try await apiGetManager.getFollowers(userId: userId)
                    followingUser = try await apiGetManager.getFollowing(userId: userId)
                } catch let error as APIGetError {
                    switch error {
                    case .invalidUrl:
                        errorMessage = "The request URL is invalid. Please check your connection."
                    case .invalidResponse:
                        errorMessage = "Unexpected response from the server. Try again later."
                    case .decodingError:
                        errorMessage = "We couldn't process the data. Please update your app."
                    case .serverError:
                        errorMessage = "The server is currently unavailable. Try again later."
                    case .userNotFound:
                        errorMessage = "We couldn't find the user you're looking for."
                    }
                    displayErrorMessage = true
                } catch {
                    errorMessage = "An unexpected error occurred. Please try again later."
                    displayErrorMessage = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
        }
    }
}

#Preview {
    FollowersPageView(userId: 1, isFollowingSelected: false, isFollowersSelected: true)
}
