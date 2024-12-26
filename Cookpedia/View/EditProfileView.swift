//
//  EditProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 15/12/2024.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    
    @State private var redirectHomePage: Bool = false
    @State private var profileUpdated: Bool = false
    
    @State private var isImagePickerPresented = false
    
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var description: String = ""
    @State private var facebook: String = ""
    @State private var youtube: String = ""
    @State private var twitter: String = ""
    @State private var instagram: String = ""
    @State private var website: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var selectedImage: UIImage?
    @State private var profilePictureUrl: String = ""
    
    @FocusState private var isTextFocused: Bool
    
    var apiGetManager = APIGetRequest()
    var apiPutManager = APIPutRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Spacer()
                            Button {
                                isImagePickerPresented = true
                            } label: {
                                if let selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
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
                                                .aspectRatio(contentMode: .fill)
                                                .clipped()
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
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(image: $selectedImage) { filename in
                                    profilePictureUrl = "profile_picture_\(filename)"
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
                                TextField(text: $description, axis: .vertical) {
                                    Text("Description")
                                        .foregroundStyle(Color("Dark4"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .textInputAutocapitalization(.never)
                                .keyboardType(.default)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                                .frame(minHeight: 32)
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
                            Text("Youtube")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                TextField(text: $youtube) {
                                    Text("Youtube")
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
                            Text("Facebook")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                TextField(text: $facebook) {
                                    Text("Facebook")
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
                            Text("Twitter")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
                                TextField(text: $twitter) {
                                    Text("Twitter")
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
                                    Text("Website")
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
            .background(Color(profileUpdated ? "BackgroundOpacity" : "Dark1"))
            .blur(radius: profileUpdated ? 4 : 0)
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
                    Button {
                        guard let currentUser = userSession.first else {
                            return
                        }
                        
                        guard let userId = Int(currentUser.userId) else {
                            return
                        }
                        
                        let updatedUser = EditUser(
                            id: userId,
                            fullName: fullName,
                            username: username,
                            description: description,
                            youtubeUrl: youtube,
                            facebookUrl: facebook,
                            twitterUrl: twitter,
                            instagramUrl: instagram,
                            websiteUrl: website,
                            city: city,
                            country: country,
                            profilePictureUrl: profilePictureUrl
                        )
                        
                        apiPutManager.updateUserProfile(userId: userId, user: updatedUser, profilePicture: selectedImage) { result in
                            switch result {
                                case .success(let message):
                                    print(message)
                                    profileUpdated = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.redirectHomePage = true
                                        profileUpdated = false
                                    }
                                case .failure(let error):
                                    print("Failed to update profile: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Image("Edit - Regular - Light - Outline")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color("MyWhite"))
                    }
                    .navigationDestination(isPresented: $redirectHomePage) {
                        TabView()
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
                
                apiGetManager.getUserDataFromUserId(userId: userId) { result in
                    switch result {
                        case .success(let user):
                            DispatchQueue.main.async {
                                self.profilePictureUrl = user.profilePictureUrl ?? ""
                                self.fullName = user.fullName
                                self.username = user.username
                                self.description = user.description ?? ""
                                self.youtube = user.youtubeUrl ?? ""
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
            if profileUpdated {
                ModalView(title: "Profile infos updated", message: "Your infos have been updated successfully")
            }
        }
    }
}

#Preview {
    EditProfileView()
}
