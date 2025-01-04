//
//  UserDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/12/2024.
//

import SwiftUI
import SwiftData

struct UserDetailsView: View {
    
    let user: UserDetails
    @State private var following: Bool = false
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    var apiDeleteManager = APIDeleteRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @State private var connectedUserId: Int?
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(user.profilePictureUrl ?? "").jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                } placeholder: {
                    Image("Ellipse")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullName)
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 18))
                    Text("@\(user.username)")
                        .foregroundStyle(Color("Greyscale300"))
                        .font(.custom("Urbanist-Medium", size: 14))
                }
            }
            Spacer()
            if connectedUserId != user.id {
                Button {
                    guard let currentUser = userSession.first else {
                        return
                    }
                    
                    guard let userId = Int(currentUser.userId) else {
                        return
                    }
                    
                    if following == true {
                        apiDeleteManager.unfollowUser(followerId: userId, followedId: user.id) { result in
                            switch result {
                                case .success(let message):
                                    following = false
                                case .failure(let error):
                                    print("Failed to unfollow user: \(error.localizedDescription)")
                            }
                        }
                    } else if following == false {
                        print("following false")
                        apiPostManager.followUser(followerId: userId, followedId: user.id) { result in
                            switch result {
                                case .success(let message):
                                    following = true
                                case .failure(let error):
                                    print("Failed to follow user : \(error.localizedDescription)")
                            }
                        }
                    }
                } label: {
                    if following {
                        Text("Following")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(width: 108, height: 38)
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .strokeBorder(Color("Primary900"), lineWidth: 2)
                            }
                    } else {
                        Text("Follow")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(width: 86, height: 38)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    }
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
            
            connectedUserId = userId
            
            apiGetManager.isFollowing(followerId: userId, followedId: user.id) { result in
                switch result {
                    case .success(let isFollowing):
                        if isFollowing {
                            following = true
                        } else {
                            following = false
                        }
                    case .failure(let error):
                        print("Failed to check follow status: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    UserDetailsView(user: UserDetails(id: 1, username: "rodolfo_goode", fullName: "Rodolfo Goode", profilePictureUrl: ""))
}
