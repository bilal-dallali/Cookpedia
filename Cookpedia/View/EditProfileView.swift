//
//  EditProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 15/12/2024.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var description: String = ""
    @State private var facebook: String = ""
    @State private var twitter: String = ""
    @State private var instagram: String = ""
    @State private var website: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var selectedImage: UIImage?
    @State private var profilePictureUrl: String = ""
    
    @FocusState private var isTextFocused: Bool
    
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Spacer()
                        Button {
                            //
                        } label: {
                            if let selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipShape(.rect(cornerRadius: .infinity))
                                    .overlay(alignment: .trailingLastTextBaseline) {
                                        Image("Edit Square - Regular - Bold")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                            } else {
                                if profilePictureUrl.isEmpty {
                                    Image("Ellipse")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .clipShape(.rect(cornerRadius: .infinity))
                                        .overlay(alignment: .trailingLastTextBaseline) {
                                            Image("Edit Square - Regular - Bold")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                } else {
                                    AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(profilePictureUrl).jpg")) { image in
                                        image
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 120, height: 120)
                                    }
                                    .overlay(alignment: .trailingLastTextBaseline) {
                                        Image("Edit Square - Regular - Bold")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Full Name")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $fullName) {
                                Text("Full Name")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Username")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $username) {
                                Text("Username")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $description) {
                                Text("Description")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    Text("Social Media")
                        .foregroundStyle(Color("Greyscale300"))
                        .font(.custom("Urbanist-Bold", size: 18))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Facebook")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $facebook) {
                                Text("facebook")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instagram")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $instagram) {
                                Text("Instagram")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    Text("More Info")
                        .foregroundStyle(Color("Greyscale300"))
                        .font(.custom("Urbanist-Bold", size: 18))
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Website")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $website) {
                                Text("website")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("City")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $city) {
                                Text("City")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Country")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $country) {
                                Text("Country")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Edit Profile")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image("More Circle - Regular - Light - Outline")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(Color("MyWhite"))
            }
        }
        .onAppear {
            guard let currentUser = userSession.first else {
                return
            }
            
            guard let userId = Int(currentUser.userId) else {
                return
            }
            
            apiGetManager.getConnectedUserUserData(userId: userId) { result in
                switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.profilePictureUrl = user.profilePictureUrl ?? ""
                            self.fullName = user.fullName
                            self.username = user.username
                            self.description = user.description ?? ""
                            self.facebook = user.facebookUrl ?? ""
                            self.twitter = user.twitterUrl ?? ""
                            self.instagram = user.instagramUrl ?? ""
                            self.website = user.websiteUrl ?? ""
                            self.city = user.city
                            self.country = user.country
                        }
                    case .failure(let error):
                        print("Failed to fetch user data: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
