//
//  RecipeDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 20/12/2024.
//

import SwiftUI
import SwiftData

import Foundation

func timeAgo(from dateString: String) -> String {
    let inputFormatter = ISO8601DateFormatter()
    inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Supporte le format ISO 8601
    
    guard let date = inputFormatter.date(from: dateString) else {
        return "Unknown time"
    }
    
    let now = Date()
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: date, to: now)
    
    if let year = components.year, year > 0 {
        return year == 1 ? "1 year ago" : "\(year) years ago"
    }
    if let month = components.month, month > 0 {
        return month == 1 ? "1 month ago" : "\(month) months ago"
    }
    if let week = components.weekOfYear, week > 0 {
        return week == 1 ? "1 week ago" : "\(week) weeks ago"
    }
    if let day = components.day, day > 0 {
        return day == 1 ? "1 day ago" : "\(day) days ago"
    }
    if let hour = components.hour, hour > 0 {
        return hour == 1 ? "1 hour ago" : "\(hour) hours ago"
    }
    if let minute = components.minute, minute > 0 {
        return minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
    }
    if let second = components.second, second > 0 {
        return second == 1 ? "1 second ago" : "\(second) seconds ago"
    }
    
    return "Just now"
}

struct RecipeDetailsView: View {
    
    @State private var recipeDetails: RecipeDetails
    let recipeId: Int
    @State private var isBookmarkSelected: Bool = false
    @State private var addedToBookmarks: Bool = false
    @State private var deleteCommentAlert: Bool = false
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    var apiDeleteManager = APIDeleteRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @State private var connectedUserId: Int? = nil
    @State private var following: Bool = false
    @State private var profilePictureUrl: String = ""
    @State private var commentText: String = ""
    @FocusState private var isCommentTextfieldFocused: Bool
    
    // Private initializer for internal use only
    private init(recipeDetails: RecipeDetails, recipeId: Int, isDropdownActivated: Bool) {
        self.recipeDetails = recipeDetails
        self.recipeId = recipeId
    }
    
    @State private var comments: [CommentsDetails] = []
    
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
                                                        apiDeleteManager.unfollowUser(followerId: userId, followedId: recipeDetails.userId) { result in
                                                            switch result {
                                                                case .success(let message):
                                                                    following = false
                                                                case .failure(let error):
                                                                    print("Failed to unfollow user: \(error.localizedDescription)")
                                                            }
                                                        }
                                                    } else if following == false {
                                                        apiPostManager.followUser(followerId: userId, followedId: recipeDetails.userId) { result in
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
                                            Text("Comments (\(comments.count))")
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
                                            ForEach(comments, id: \.id) { comment in
                                                CommentSlotView(comment: comment, deleteCommentAlert: $deleteCommentAlert)
                                                    .alert("", isPresented: $deleteCommentAlert) {
                                                        Button("Cancel", role: .cancel) {
                                                            
                                                        }
                                                        Button("Delete", role: .destructive) {
                                                            apiDeleteManager.deleteComment(commentId: comment.id) { result in
                                                                switch result {
                                                                    case .success:
                                                                        apiGetManager.getCommentsOrderAsc(forRecipeId: recipeDetails.id) { result in
                                                                            switch result {
                                                                                case .success(let comments):
                                                                                    self.comments = comments
                                                                                case .failure(let error):
                                                                                    print("error \(error.localizedDescription)")
                                                                            }
                                                                        }
                                                                    case .failure:
                                                                        print("Didn't delete the comment")
                                                                }
                                                            }
                                                        }
                                                    } message: {
                                                        Text("Are you sure you want to delete this comment?")
                                                            .foregroundStyle(Color("Primary900"))
                                                            .font(.custom("Urbanist-Regular", size: 16))
                                                    }
                                            }
                                            
                                            HStack(spacing: 16) {
                                                AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(profilePictureUrl).jpg")) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipped()
                                                        .frame(width: 48, height: 48)
                                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                                } placeholder: {
                                                    Image("Ellipse")
                                                        .resizable()
                                                        .frame(width: 48, height: 48)
                                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                                }
                                                HStack(spacing: 12) {
                                                    TextField(text: $commentText) {
                                                        Text("Add a comment")
                                                            .foregroundStyle(Color("Greyscale500"))
                                                            .font(.custom("Urbanist-Regular", size: 16))
                                                    }
                                                    .autocorrectionDisabled(true)
                                                    .keyboardType(.default)
                                                    .foregroundStyle(Color("MyWhite"))
                                                    .font(.custom("Urbanist-Semibold", size: 16))
                                                    .focused($isCommentTextfieldFocused)
                                                    Button {
                                                        guard let currentUser = userSession.first else {
                                                            return
                                                        }
                                                        
                                                        guard let userId = Int(currentUser.userId) else {
                                                            return
                                                        }
                                                        
                                                        let comment = CommentsPost(userId: userId, recipeId: recipeDetails.id, comment: commentText)
                                                        
                                                        apiPostManager.postComment(comment: comment) { result in
                                                            print("result \(result)")
                                                            switch result {
                                                                case .success(let response):
                                                                    print("comment poster successfully \(response)")
                                                                    commentText = ""
                                                                    //DispatchQueue.main.asyncAfter(deadline: .now() + 5)
                                                                    apiGetManager.getCommentsOrderAsc(forRecipeId: recipeDetails.id) { result in
                                                                        switch result {
                                                                            case .success(let comments):
                                                                                print("comment loaded successfully after being posted \(comments)")
                                                                                self.comments = comments
                                                                            case .failure(let error):
                                                                                print("error \(error.localizedDescription)")
                                                                                print("comment not loaded after being posted")
                                                                        }
                                                                    }
                                                                    
                                                                case .failure(let error):
                                                                    print("Failed to post comment\(error)")
                                                            }
                                                        }
                                                    } label: {
                                                        Image("Send - Regular - Bold")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundStyle(Color("Primary900"))
                                                    }
                                                }
                                                .padding(.horizontal, 20)
                                                .frame(height: 58)
                                                .background(Color(isCommentTextfieldFocused ? "TransparentRed" : "Dark2"))
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                                .overlay {
                                                    if isCommentTextfieldFocused {
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .strokeBorder(Color("Primary900"), lineWidth: 1)
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
                                                        following = true
                                                    } else {
                                                        following = false
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
                                                    }
                                                case .failure(let error):
                                                    print("Failed to fetch user data: \(error.localizedDescription)")
                                            }
                                        }
                                        
                                        apiGetManager.getCommentsOrderAsc(forRecipeId: recipeDetails.id) { result in
                                            print("Trying to get comments \(result)")
                                            switch result {
                                                case .success(let comments):
                                                    print("comments loaded successfully on page landing \(comments)")
                                                    self.comments = comments
                                                case .failure(let error):
                                                    print("error \(error.localizedDescription)")
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
                                    print("increment views")
                                case .failure(let error):
                                    print("Failed to increment views: \(error.localizedDescription)")
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
            .onTapGesture {
                isCommentTextfieldFocused = false
            }
        }
    }
}

#Preview {
    RecipeDetailsView(recipeId: 1)
}
