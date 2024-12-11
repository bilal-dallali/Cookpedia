//
//  ProfilePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI
import SwiftData

struct MyProfilePageView: View {
    
    @State private var isRecipeSelected: Bool = true
    @State private var isAboutSelected: Bool = false
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    
    @State private var profilePictureUrl: String = ""
    @State private var fullName: String = "Andrew Ainsley"
    @State private var username: String = "andrew_ainsley"
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 0) {
                        Image("logo")
                            .resizable()
                            .frame(width: 28, height: 28)
                        Text("Profile")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 24))
                            .padding(.leading, 16)
                        Spacer()
                        Button {
                            //
                        } label: {
                            Image("send")
                                
                        }
                        .padding(.trailing, 20)
                        
                        Button {
                            //
                        } label: {
                            Image("setting")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 20) {
                                if profilePictureUrl.isEmpty {
                                    Image("ellipse")
                                        .resizable()
                                        .frame(width: 72, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                } else {
                                    AsyncImage(url: URL(string: profilePictureUrl)) { image in
                                        image
                                    } placeholder: {
                                        ProgressView()
                                        //Text(profilePictureUrl)
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
                                    print("test")
                                } label: {
                                    HStack(spacing: 8) {
                                        Image("edit")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                        Text("Edit")
                                            .foregroundStyle(Color("Primary900"))
                                            .font(.custom("Urbanist-Semibold", size: 16))
                                    }
                                    .frame(width: 93, height: 38)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .foregroundStyle(Color("Dark4"))
                                        .frame(height: 1)
                                }
                            HStack(spacing: 16) {
                                Button {
                                    print("recipes")
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("125")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Text("recipes")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 12))
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                Divider()
                                    .overlay {
                                        Rectangle()
                                            .foregroundStyle(Color("Dark4"))
                                            .frame(width: 1)
                                    }
                                Button {
                                    print("following")
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("104")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Text("following")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 12))
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                Divider()
                                    .overlay {
                                        Rectangle()
                                            .foregroundStyle(Color("Dark4"))
                                            .frame(width: 1)
                                    }
                                Button {
                                    print("followers")
                                } label: {
                                    VStack(spacing: 4) {
                                        Text("5,278")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        Text("followers")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 12))
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                
                            }
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .foregroundStyle(Color("Dark4"))
                                        .frame(height: 1)
                                }
                            HStack(spacing: 0) {
                                Button {
                                    isRecipeSelected = true
                                    isAboutSelected = false
                                } label: {
                                    VStack(spacing: 12) {
                                        if isRecipeSelected {
                                            Text("Recipes")
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                            Divider()
                                                .overlay {
                                                    Rectangle()
                                                        .fill(Color("Primary900"))
                                                        .frame(height: 4)
                                                        .clipShape(.rect(cornerRadius: 100))
                                                }
                                        } else {
                                            Text("Recipes")
                                                .foregroundStyle(Color("Greyscale700"))
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                            Divider()
                                                .overlay {
                                                    Rectangle()
                                                        .fill(Color("Dark4"))
                                                        .frame(height: 2)
                                                        .clipShape(.rect(cornerRadius: 100))
                                                }
                                        }
                                    }
                                }
                                
                                Button {
                                    isRecipeSelected = false
                                    isAboutSelected = true
                                } label: {
                                    VStack(spacing: 12) {
                                        if isAboutSelected {
                                            Text("About")
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                            Divider()
                                                .overlay {
                                                    Rectangle()
                                                        .fill(Color("Primary900"))
                                                        .frame(height: 4)
                                                        .clipShape(.rect(cornerRadius: 100))
                                                }
                                        } else {
                                            Text("About")
                                                .foregroundStyle(Color("Greyscale700"))
                                                .font(.custom("Urbanist-SemiBold", size: 18))
                                            Divider()
                                                .overlay {
                                                    Rectangle()
                                                        .fill(Color("Dark4"))
                                                        .frame(height: 2)
                                                        .clipShape(.rect(cornerRadius: 100))
                                                }
                                        }
                                    }
                                }
                                
                            }
                            .frame(height: 41)
                            .frame(maxWidth: .infinity)
                        }
                        if isRecipeSelected {
                            Text("Recipe")
                        } else if isAboutSelected {
                            Text("About")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 16)
            .padding(.horizontal, 24)
            .background(Color("Dark1"))
            .onAppear {
                guard let currentUser = userSession.first else {
                    print("Failed to decode userId")
                    return
                }
                
                guard let userId = Int(currentUser.userId) else {
                    print("Failed to convert userId to Int")
                    return
                }
                print("user id 2000 \(userId)")
                apiGetManager.getUserData(userId: userId) { result in
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.profilePictureUrl = user.profilePictureUrl ?? ""
                            self.fullName = user.fullName
                            self.username = user.username
                        }
                    case .failure(let error):
                        print("Failed to fetch user data: \(error.localizedDescription)")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyProfilePageView()
}
