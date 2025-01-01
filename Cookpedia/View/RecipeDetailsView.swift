//
//  RecipeDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 20/12/2024.
//

import SwiftUI
import SwiftData

struct RecipeDetailsView: View {
    
    @State private var recipeDetails: RecipeDetails
    let recipeId: Int
    @State private var isBookmarkSelected: Bool = false
    @State private var addedToBookmarks: Bool = false
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    var apiDeleteManager = APIDeleteRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @State private var connectedUserId: Int? = nil
    @State private var following: Bool = false
    
    // Private initializer for internal use only
    private init(recipeDetails: RecipeDetails, recipeId: Int) {
        self.recipeDetails = recipeDetails
        self.recipeId = recipeId
    }
    
    // Public initializer for NavigationLink and external use
    init(recipeId: Int) {
        self.recipeId = recipeId
        self.recipeDetails = RecipeDetails(
            id: recipeId,
            userId: 0,
            title: "Loading...",
            recipeCoverPictureUrl1: "",
            recipeCoverPictureUrl2: "",
            description: "",
            cookTime: "",
            serves: "",
            origin: "",
            ingredients: [],
            instructions: [],
            fullName: "",
            profilePictureUrl: "",
            username: ""
        )
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                if recipeDetails.recipeCoverPictureUrl2.isEmpty {
                                    AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl1).jpg")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .frame(width: geometry.size.width, height: 430)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color("Greyscale400"))
                                            .frame(width: geometry.size.width, height: 430)
                                    }
                                } else {
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 0) {
                                            AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl1).jpg")) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipped()
                                                    .frame(width: geometry.size.width, height: 430)
                                            } placeholder: {
                                                Rectangle()
                                                    .fill(Color("Greyscale400"))
                                                    .frame(width: geometry.size.width, height: 430)
                                            }
                                            
                                            AsyncImage(url: URL(string: "\(baseUrl)/recipes/recipe-cover/\(recipeDetails.recipeCoverPictureUrl2).jpg")) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipped()
                                                    .frame(width: geometry.size.width, height: 430)
                                            } placeholder: {
                                                Rectangle()
                                                    .fill(Color("Greyscale400"))
                                                    .frame(width: geometry.size.width, height: 430)
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                    .scrollTargetBehavior(.paging)
                                }
                                
                                VStack(alignment: .leading, spacing: 24) {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text(recipeDetails.title)
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 32))
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .frame(height: 1)
                                                    .foregroundStyle(Color("Dark4"))
                                            }
                                        
                                        if connectedUserId != recipeDetails.userId {
                                            HStack {
                                                NavigationLink {
                                                    ProfilePageView(userId: recipeDetails.userId)
                                                } label: {
                                                    HStack(spacing: 20) {
                                                        AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(recipeDetails.profilePictureUrl).jpg")) { image in
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                                .clipped()
                                                                .frame(width: 72, height: 72)
                                                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                                        } placeholder: {
                                                            Rectangle()
                                                                .fill(Color("Greyscale400"))
                                                                .frame(width: 72, height: 72)
                                                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                                        }
                                                        VStack(alignment: .leading, spacing: 4) {
                                                            Text(recipeDetails.fullName)
                                                                .foregroundStyle(Color("MyWhite"))
                                                                .font(.custom("Urbanist-Bold", size: 20))
                                                            Text("@\(recipeDetails.username)")
                                                                .foregroundStyle(Color("MyWhite"))
                                                                .font(.custom("Urbanist-Medium", size: 16))
                                                        }
                                                    }
                                                }
                                                Spacer()
                                                Button {
                                                    guard let currentUser = userSession.first else {
                                                        return
                                                    }
                                                    
                                                    guard let userId = Int(currentUser.userId) else {
                                                        return
                                                    }

                                                    if following == true {
                                                        print("following true")
                                                        apiDeleteManager.unfollowUser(followerId: userId, followedId: recipeDetails.userId) { result in
                                                            switch result {
                                                                case .success(let message):
                                                                    print("Success: \(message)")
                                                                    following = false
                                                                case .failure(let error):
                                                                    print("Failed to unfollow user: \(error.localizedDescription)")
                                                            }
                                                        }
                                                    } else if following == false {
                                                        print("following false")
                                                        apiPostManager.followUser(followerId: userId, followedId: recipeDetails.userId) { result in
                                                            switch result {
                                                                case .success(let message):
                                                                    print("message \(message)")
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
                                        } else {
                                            HStack(spacing: 20) {
                                                AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(recipeDetails.profilePictureUrl).jpg")) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipped()
                                                        .frame(width: 72, height: 72)
                                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                                } placeholder: {
                                                    Rectangle()
                                                        .fill(Color("Greyscale400"))
                                                        .frame(width: 72, height: 72)
                                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                                }
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(recipeDetails.fullName)
                                                        .foregroundStyle(Color("MyWhite"))
                                                        .font(.custom("Urbanist-Bold", size: 20))
                                                    Text("@\(recipeDetails.username)")
                                                        .foregroundStyle(Color("MyWhite"))
                                                        .font(.custom("Urbanist-Medium", size: 16))
                                                }
                                                Spacer()
                                            }
                                        }
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .frame(height: 1)
                                                    .foregroundStyle(Color("Dark4"))
                                            }
                                        Text(recipeDetails.description)
                                            .foregroundStyle(Color("Greyscale50"))
                                            .font(.custom("Urbanist-Medium", size: 18))
                                        HStack(spacing: 12) {
                                            VStack(spacing: 6) {
                                                HStack(spacing: 6) {
                                                    Image("Time Circle - Regular - Light - Outline")
                                                        .resizable()
                                                        .frame(width: 16, height: 16)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text("\(recipeDetails.cookTime) mins")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Semibold", size: 14))
                                                }
                                                Text("cook time")
                                                    .foregroundStyle(Color("Greyscale300"))
                                                    .font(.custom("Urbanist-Medium", size: 12))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 60)
                                            .background(Color("Dark3"))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            VStack(spacing: 6) {
                                                HStack(spacing: 6) {
                                                    Image("Profile - Regular - Light - Outline")
                                                        .resizable()
                                                        .frame(width: 16, height: 16)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text("\(recipeDetails.serves) serving")
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Semibold", size: 14))
                                                }
                                                Text("serve")
                                                    .foregroundStyle(Color("Greyscale300"))
                                                    .font(.custom("Urbanist-Medium", size: 12))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 60)
                                            .background(Color("Dark3"))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            VStack(spacing: 6) {
                                                HStack(spacing: 6) {
                                                    Image("Location - Regular - Light - Outline")
                                                        .resizable()
                                                        .frame(width: 16, height: 16)
                                                        .foregroundStyle(Color("Primary900"))
                                                    Text(recipeDetails.origin)
                                                        .foregroundStyle(Color("Primary900"))
                                                        .font(.custom("Urbanist-Semibold", size: 14))
                                                        .lineLimit(1)
                                                        .truncationMode(.tail)
                                                }
                                                Text("origin")
                                                    .foregroundStyle(Color("Greyscale300"))
                                                    .font(.custom("Urbanist-Medium", size: 12))
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 60)
                                            .background(Color("Dark3"))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                        }
                                    }
                                    Divider()
                                        .overlay {
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundStyle(Color("Dark4"))
                                        }
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text("Ingredients:")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        VStack(alignment: .leading, spacing: 12) {
                                            ForEach(recipeDetails.ingredients, id: \.index) { ingredient in
                                                HStack(spacing: 16) {
                                                    Circle()
                                                        .foregroundStyle(Color("Dark3"))
                                                        .frame(width: 32, height: 32)
                                                        .overlay {
                                                            Text("\(ingredient.index)")
                                                                .foregroundStyle(Color("Primary900"))
                                                                .font(.custom("Urbanist-Semibold", size: 16))
                                                        }
                                                    Text(ingredient.ingredient)
                                                        .foregroundStyle(Color("MyWhite"))
                                                        .font(.custom("Urbanist-Medium", size: 18))
                                                }
                                            }
                                        }
                                    }
                                    Divider()
                                        .overlay {
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundStyle(Color("Dark4"))
                                        }
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text("Instructions:")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 24))
                                        ForEach(recipeDetails.instructions, id: \.index) { instruction in
                                            HStack(alignment: .top, spacing: 16) {
                                                Circle()
                                                    .foregroundStyle(Color("Dark3"))
                                                    .frame(width: 32, height: 32)
                                                    .overlay {
                                                        Text("\(instruction.index)")
                                                            .foregroundStyle(Color("Primary900"))
                                                            .font(.custom("Urbanist-Semibold", size: 16))
                                                    }
                                                VStack(alignment: .leading, spacing: 12) {
                                                    Text("\(instruction.instruction)")
                                                        .foregroundStyle(Color("MyWhite"))
                                                        .font(.custom("Urbanist-Medium", size: 18))
                                                    HStack(spacing: 8) {
                                                        AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl1 ?? "").jpg")) { image in
                                                            image
                                                                .resizable()
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 80)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        } placeholder: {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .foregroundStyle(Color("Dark1"))
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 0)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        }
                                                        AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl2 ?? "").jpg")) { image in
                                                            image
                                                                .resizable()
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 80)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        } placeholder: {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .foregroundStyle(Color("Dark1"))
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 0)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        }
                                                        AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/\(instruction.instructionPictureUrl3 ?? "").jpg")) { image in
                                                            image
                                                                .resizable()
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 80)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        } placeholder: {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .foregroundStyle(Color("Dark1"))
                                                                .frame(maxWidth: .infinity)
                                                                .frame(height: 0)
                                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Divider()
                                        .overlay {
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundStyle(Color("Dark4"))
                                        }
                                    VStack(spacing: 20) {
                                        HStack {
                                            Text("Comments")
                                                .foregroundStyle(Color("MyWhite"))
                                                .font(.custom("Urbanist-Bold", size: 24))
                                            Spacer()
                                            Button {
                                                //
                                            } label: {
                                                Image("Arrow - Right - Regular - Light - Outline")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundStyle(Color("Primary900"))
                                            }
                                        }
                                        
                                        VStack(spacing: 20) {
                                            CommentSlotView()
                                            CommentSlotView()
                                            CommentSlotView()
                                            CommentSlotView()
                                            CommentSlotView()
                                            
                                        }
                                    }
                                    
                                    Divider()
                                        .overlay {
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundStyle(Color("Dark4"))
                                        }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    .ignoresSafeArea(edges: .all)
                    .background(Color("Dark1"))
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            BackButtonView()
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            HStack(spacing: 20) {
                                Button {
                                    guard let currentUser = userSession.first else {
                                        return
                                    }
                                    
                                    guard let userId = Int(currentUser.userId) else {
                                        return
                                    }
                                    
                                    apiPostManager.toggleBookmark(userId: userId, recipeId: recipeDetails.id, isBookmarked: isBookmarkSelected) { result in
                                        switch result {
                                            case .success:
                                                isBookmarkSelected.toggle()
                                                if isBookmarkSelected {
                                                    addedToBookmarks = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                        addedToBookmarks = false
                                                    }
                                                }
                                            case .failure:
                                                print("failure")
                                        }
                                    }
                                } label: {
                                    Image(isBookmarkSelected ? "Bookmark - Regular - Bold" : "Bookmark - Regular - Light - Outline")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundStyle(Color(isBookmarkSelected ? "Primary900" : "MyWhite"))
                                }

                                Button {
                                    //
                                } label: {
                                    Image("More Circle - Regular - Light - Outline")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundStyle(Color("MyWhite"))
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
                        
                        apiGetManager.getBookmark(userId: userId, recipeId: recipeDetails.id) { result in
                            switch result {
                                case .success(let jsonResult):
                                    if jsonResult {
                                        isBookmarkSelected = true
                                    }
                                case .failure(let error):
                                    print("failure \(error.localizedDescription)")
                            }
                        }
                        
                        apiGetManager.getRecipeDetails(recipeId: recipeId) { result in
                            DispatchQueue.main.async {
                                switch result {
                                    case .success(let details):
                                        self.recipeDetails = details
                                        
                                        apiGetManager.isFollowing(followerId: userId, followedId: recipeDetails.userId) { result in
                                            switch result {
                                                case .success(let isFollowing):
                                                    if isFollowing {
                                                        print("User is following the other user.")
                                                        following = true
                                                    } else {
                                                        print("User is not following the other user.")
                                                        following = false
                                                    }
                                                case .failure(let error):
                                                    print("Failed to check follow status: \(error.localizedDescription)")
                                            }
                                        }
                                    case .failure(let error):
                                        print("error \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        apiPostManager.incrementViews(recipeId: recipeId) { result in
                            switch result {
                                case .success:
                                    print("increment search")
                                case .failure(let error):
                                    print("Failed to check follow status: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                if addedToBookmarks {
                    NavigationLink {
                        MyBookmarkView()
                    } label: {
                        HStack(spacing: 8) {
                            Image("Tick Square - Regular - Bold")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.28, blue: 0.29, opacity: 1), Color(red: 1, green: 0.45, blue: 0.46, opacity: 1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            Text("Added to Bookmark")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 18))
                        }
                        .frame(width: 225, height: 61)
                        .background(Color("Dark3"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.28, blue: 0.29, opacity: 1), Color(red: 1, green: 0.45, blue: 0.46, opacity: 1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        
                        .padding(.top, 120)
                        .ignoresSafeArea()
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(recipeId: 1)
}
