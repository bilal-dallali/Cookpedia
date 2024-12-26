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
    @State private var isRecipeSelected: Bool = false
    @State private var isAboutSelected: Bool = true
    @State private var publishedRecipes: [RecipeTitleCover] = []
    
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
                        Divider()
                            .overlay {
                                Rectangle()
                                    .foregroundStyle(Color("Dark4"))
                                    .frame(height: 1)
                            }
                        
                        HStack(spacing: 16) {
                            Button {
                                //
                            } label: {
                                VStack(spacing: 4) {
                                    Text("245")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Text("recipes")
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
                            Button {
                                //
                            } label: {
                                VStack(spacing: 4) {
                                    Text("127")
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
                            Button {
                                //
                            } label: {
                                VStack(spacing: 4) {
                                    Text("29.5k")
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
                                    //WelcomeView()
                                    //print("recipe id: \(recipe.id)")
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
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Description")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                    Text(description)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Medium", size: 16))
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
                                            Link(destination: URL(string: "https://\(youtube)")!) {
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
                                            Link(destination: URL(string: "https://\(facebook)")!) {
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
                                            Link(destination: URL(string: "https://\(twitter)")!) {
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
                                            Link(destination: URL(string: "https://\(instagram)")!) {
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
                                                Text("www.exampledomain.com")
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
                print("userid \(userId)")
                
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
                                //self.createdAt = createdAt
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
