//
//  ProfilePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/12/2024.
//

import SwiftUI
import SwiftData

struct ProfilePageView: View {
    
    let userId: Int
    @State private var isRecipeSelected: Bool = true
    @State private var isAboutSelected: Bool = false
    
    @State private var following: Bool = false
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    @State private var profilePictureUrl: String = ""
    @State private var fullName: String = "unkwnown"
    @State private var username: String = "unknown"
    @State private var description: String = "The user hasn't filled out their profile yet"
    @State private var youtube: String = ""
    @State private var facebook: String = ""
    @State private var twitter: String = ""
    @State private var instagram: String = ""
    @State private var website: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var createdAt: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            if profilePictureUrl.isEmpty {
                                Image("Ellipse")
                                    .resizable()
                                    .frame(width: 72, height: 72)
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            } else {
                                AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(profilePictureUrl).jpg")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .frame(width: 72, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 72, height: 72)
                                }
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(fullName)
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                Text("@\(username)")
                                    .foregroundStyle(Color("Greyscale300"))
                                    .font(.custom("Urbanist-Medium", size: 14))
                            }
                            Spacer()
                            Button {
                                following.toggle()
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
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .background(Color("Dark1"))
            .onAppear {
//                guard let currentUser = userSession.first else {
//                    return
//                }
//                
//                guard let userId = Int(currentUser.userId) else {
//                    return
//                }
                
                apiGetManager.getUserDataFromUserId(userId: userId) { result in
                    switch result {
                        case .success(let anyway):
                            DispatchQueue.main.async {
                                self.profilePictureUrl = anyway.profilePictureUrl ?? ""
                                self.fullName = anyway.fullName
                                self.username = anyway.username
                                self.description = anyway.description
                                self.youtube = anyway.youtubeUrl
                                self.facebook = anyway.facebookUrl
                                self.twitter = anyway.twitterUrl
                                self.instagram = anyway.instagramUrl
                                self.website = anyway.websiteUrl
                                self.city = anyway.city
                                self.country = anyway.country
                                self.createdAt = createdAt
    
                            }
                        case .failure(let error):
                            print("Failed to fetch user data: \(error.localizedDescription)")
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
    ProfilePageView(userId: 1)
}
