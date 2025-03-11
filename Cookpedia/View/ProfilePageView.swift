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
    @State private var publishedRecipes: [RecipeTitleCover] = []
    
    @State private var following: Bool = false
    
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    var apiDeleteManager = APIDeleteRequest()
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
    @State private var followingCount: Int = 0
    @State private var followersCount: Int = 0
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 16) {
                        HStack(spacing: 0) {
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
                            }
                            Spacer()
                            if userId != Int(userSession.first!.userId) {
                                Button {
                                    guard let currentUser = userSession.first else {
                                        return
                                    }
                                    
                                    let connectedUserId = currentUser.userId
                                    
                                    if following == true {
                                        apiDeleteManager.unfollowUser(followerId: connectedUserId, followedId: userId) { result in
                                            switch result {
                                                case .success:
                                                    following = false
                                                case .failure(let error):
                                                    print("Failed to unfollow user: \(error.localizedDescription)")
                                            }
                                        }
                                    } else if following == false {
//                                        apiPostManager.followUser(followerId: connectedUserId, followedId: userId) { result in
//                                            switch result {
//                                                case .success:
//                                                    following = true
//                                                case .failure(let error):
//                                                    print("Failed to follow user : \(error.localizedDescription)")
//                                            }
//                                        }
                                        
                                        Task {
                                            do {
                                                let message = try await apiPostManager.followUser(followerId: connectedUserId, followedId: userId)
                                                following = true
                                                
                                            } catch {
                                                print("Failed to follow user")
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
                        Divider()
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(Color("Dark4"))
                                    .frame(height: 1)
                            }
                        
                        HStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Text("\(publishedRecipes.count)")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 24))
                                Text("recipes")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Medium", size: 12))
                            }
                            .frame(maxWidth: .infinity)
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .foregroundStyle(Color("Dark4"))
                                        .frame(width: 1)
                                }
                            NavigationLink {
                                FollowersPageView(userId: userId, isFollowingSelected: true, isFollowersSelected: false)
                            } label: {
                                VStack(spacing: 4) {
                                    Text("\(followingCount)")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Text("following")
                                        .foregroundStyle(Color("MyWhite"))
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
                            NavigationLink {
                                FollowersPageView(userId: userId, isFollowingSelected: false, isFollowersSelected: true)
                            } label: {
                                VStack(spacing: 4) {
                                    Text("\(followersCount)")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Text("followers")
                                        .foregroundStyle(Color("MyWhite"))
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
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(publishedRecipes, id: \.id) { recipe in
                                NavigationLink {
                                    RecipeDetailsView(recipeId: recipe.id)
                                } label: {
                                    RecipeCardView(recipe: recipe)
                                        .frame(height: 260)
                                }
                            }
                        }
                    } else {
                        VStack(spacing: 16) {
                            if !description.isEmpty {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Description")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 18))
                                        Text(description)
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Medium", size: 16))
                                    }
                                    Spacer()
                                }
                                Divider()
                                    .overlay {
                                        Rectangle()
                                            .foregroundStyle(Color("Dark4"))
                                            .frame(height: 1)
                                    }
                            }
                            
                            if !youtube.isEmpty || !facebook.isEmpty || !twitter.isEmpty || !instagram.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Social Media")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                    VStack(alignment: .leading, spacing: 14) {
                                        if !youtube.isEmpty {
                                            Link(destination: URL(string: "https://youtube.com/@\(youtube)")!) {
                                                HStack(spacing: 12) {
                                                    Image("Youtube")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text("Youtube")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Medium", size: 16))
                                                    Spacer()
                                                }
                                            }
                                        }
                                        
                                        if !facebook.isEmpty {
                                            Link(destination: URL(string: "https://facebook.com/\(facebook)")!) {
                                                HStack(spacing: 12) {
                                                    Image("Facebook")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text("Facebook")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Medium", size: 16))
                                                    Spacer()
                                                }
                                            }
                                        }
                                        
                                        if !twitter.isEmpty {
                                            Link(destination: URL(string: "https://x.com/\(twitter)")!) {
                                                HStack(spacing: 12) {
                                                    Image("Twitter")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text("Twitter")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Medium", size: 16))
                                                    Spacer()
                                                }
                                            }
                                        }
                                        
                                        if !instagram.isEmpty {
                                            Link(destination: URL(string: "https://instagram.com/\(instagram)")!) {
                                                HStack(spacing: 12) {
                                                    Image("Instagram")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text("Instagram")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Medium", size: 16))
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                                Divider()
                                    .overlay {
                                        Rectangle()
                                            .foregroundStyle(Color("Dark4"))
                                            .frame(height: 1)
                                    }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("More Info")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 18))
                                VStack(alignment: .leading, spacing: 14) {
                                    if !website.isEmpty {
                                        Link(destination: URL(string: "https://\(website)")!) {
                                            HStack(spacing: 12) {
                                                Image("World")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundStyle(Color("Primary900"))
                                                Text(website)
                                                    .tint(Color("Primary900"))
                                                    .font(.custom("Urbanist-Medium", size: 16))
                                                Spacer()
                                            }
                                        }
                                    }
                                    
                                    HStack(spacing: 12) {
                                        Image("Location - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Greyscale300"))
                                        Text("\(city), \(country)")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 16))
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 12) {
                                        Image("Info Square - Regular - Light - Outline")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Greyscale300"))
                                        Text("Joined since \(createdAt)")
                                            .foregroundStyle(Color("Greyscale300"))
                                            .font(.custom("Urbanist-Medium", size: 16))
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
            .onAppear {
                guard let currentUser = userSession.first else {
                    return
                }
                
                let connectedUserId = currentUser.userId
                
                apiGetManager.isFollowing(followerId: connectedUserId, followedId: userId) { result in
                    switch result {
                        case .success(let isFollowing):
                            if isFollowing {
                                following = true
                            } else {
                                print("User is not following the other user.")
                            }
                        case .failure(let error):
                            print("Failed to check follow status: \(error.localizedDescription)")
                    }
                }
                
                apiGetManager.getUserDataFromUserId(userId: userId) { result in
                    switch result {
                        case .success(let user):
                            DispatchQueue.main.async {
                                self.profilePictureUrl = user.profilePictureUrl ?? ""
                                self.fullName = user.fullName
                                self.username = user.username
                                self.description = user.description ?? ""
                                self.youtube = user.youtube ?? ""
                                self.facebook = user.facebook ?? ""
                                self.twitter = user.twitter ?? ""
                                self.instagram = user.instagram ?? ""
                                self.website = user.website ?? ""
                                self.city = user.city
                                self.country = user.country
                                self.createdAt = formatDate(from: user.createdAt)
                            }
                        case .failure(let error):
                            print("Failed to fetch user data: \(error.localizedDescription)")
                    }
                }
                
                apiGetManager.getPublishedRecipesFromUserId(userId: userId, published: true) { result in
                    switch result {
                        case .success(let recipes):
                            DispatchQueue.main.async {
                                self.publishedRecipes = recipes
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                print("Error fetching recipes:", error.localizedDescription)
                            }
                    }
                }
                
                apiGetManager.getFollowingCount(userId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let count):
                                self.followingCount = count
                            case .failure(let error):
                                print("Failed to fetch following count: \(error.localizedDescription)")
                        }
                    }
                }
                
                apiGetManager.getFollowersCount(userId: userId) { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(let count):
                                self.followersCount = count
                            case .failure(let error):
                                print("Failed to fetch followers count: \(error.localizedDescription)")
                        }
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
    ProfilePageView(userId: 2)
}
