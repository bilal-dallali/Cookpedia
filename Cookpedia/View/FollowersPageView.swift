//
//  FollowersPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/12/2024.
//

import SwiftUI

struct FollowersPageView: View {
    
    let userId: Int
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
                        VStack(spacing: 20) {
                            ForEach(followingUser, id: \.id) { user in
                                Button {
                                    //
                                } label: {
                                    UserDetailsView(user: user)
                                }
                            }
                        }
                    } else if isFollowersSelected {
                        VStack(spacing: 20) {
                            ForEach(followerUser, id: \.id) { user in
                                Button {
                                    //
                                } label: {
                                    UserDetailsView(user: user)
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
            .onAppear {
                apiGetManager.getFollowers(userId: userId) { result in
                    switch result {
                        case .success(let followers):
                            DispatchQueue.main.async {
                                self.followerUser = followers
                            }
                        case .failure(let error):
                            print("Error fetching followers: \(error.localizedDescription)")
                    }
                }
                
                apiGetManager.getFollowing(userId: userId) { result in
                    switch result {
                        case .success(let following):
                            DispatchQueue.main.async {
                                self.followingUser = following
                            }
                        case .failure(let error):
                            print("Error fetching following: \(error.localizedDescription)")
                    }
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
