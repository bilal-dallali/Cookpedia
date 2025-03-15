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
    @State var isSearch: Bool
    @State private var isBookmarkSelected: Bool = false
    @State private var addedToBookmarks: Bool = false
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
    @State private var scrollPosition = ScrollPosition()
    @State private var paddingBottom: CGFloat = 0
    @State private var scrollToBottomKey: String = UUID().uuidString
    @State private var refreshComment: Bool = false
    
    // Private initializer for internal use only
    private init(recipeDetails: RecipeDetails, recipeId: Int, isSearch: Bool, isDropdownActivated: Bool) {
        self.recipeDetails = recipeDetails
        self.recipeId = recipeId
        self.isSearch = isSearch
    }
    
    @State private var comments: [CommentsDetails] = []
    
    // Public initializer for NavigationLink and external use
    init(recipeId: Int, isSearch: Bool) {
        self.recipeId = recipeId
        self.isSearch = isSearch
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
                        ScrollViewReader { proxy in
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
                                                        
                                                        let userId = currentUser.userId
                                                        
                                                        if following == true {
                                                            Task {
                                                                do {
                                                                    _ = try await apiDeleteManager.unfollowUser(followerId: userId, followedId: recipeDetails.userId)
                                                                    DispatchQueue.main.async {
                                                                        following = false
                                                                    }
                                                                } catch {
                                                                    print("Failed to unfollow user")
                                                                }
                                                            }
                                                        } else if following == false {
                                                            Task {
                                                                do {
                                                                    _ = try await apiPostManager.followUser(followerId: userId, followedId: recipeDetails.userId)
                                                                    DispatchQueue.main.async {
                                                                        following = true
                                                                    }
                                                                    
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
                                                NavigationLink {
                                                    CommentsView(recipeId: recipeDetails.id)
                                                } label: {
                                                    Image("Arrow - Right - Regular - Light - Outline")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(Color("Primary900"))
                                                }
                                            }
                                            
                                            VStack(spacing: 20) {
                                                ForEach(comments.prefix(5).reversed(), id: \.id) { comment in
                                                    CommentSlotView(comment: comment, refreshComment: $refreshComment)
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
                                                        .submitLabel(.done)
                                                        .onSubmit {
                                                            guard let currentUser = userSession.first else {
                                                                return
                                                            }
                                                            
                                                            let userId = currentUser.userId
                                                            
                                                            let comment = CommentsPost(userId: userId, recipeId: recipeDetails.id, comment: commentText)
                                                            
                                                            Task {
                                                                do {
                                                                    let response = try await apiPostManager.postComment(comment: comment)
                                                                    print("Commentaire posté : \(response)")
                                                                    commentText = ""
                                                                    withAnimation {
                                                                        proxy.scrollTo(scrollToBottomKey, anchor: .bottom)
                                                                    }
                                                                    Task {
                                                                        do {
                                                                            let comments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
                                                                            self.comments = comments
                                                                        } catch {
                                                                            print("Failed to fetch comments")
                                                                        }
                                                                    }
                                                                    
                                                                } catch {
                                                                    print("Erreur lors de l'ajout du commentaire : \(error.localizedDescription)")
                                                                }
                                                            }
                                                        }
                                                        Button {
                                                            guard let currentUser = userSession.first else {
                                                                return
                                                            }
                                                            
                                                            let userId = currentUser.userId
                                                            
                                                            let comment = CommentsPost(userId: userId, recipeId: recipeDetails.id, comment: commentText)
                                                            
                                                            Task {
                                                                do {
                                                                    let response = try await apiPostManager.postComment(comment: comment)
                                                                    print("Commentaire posté : \(response)")
                                                                    commentText = ""
                                                                    withAnimation {
                                                                        proxy.scrollTo(scrollToBottomKey, anchor: .bottom)
                                                                    }
                                                                    Task {
                                                                        do {
                                                                            let comments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
                                                                            self.comments = comments
                                                                        } catch {
                                                                            print("Failed to fetch comments")
                                                                        }
                                                                    }
                                                                    
                                                                } catch {
                                                                    print("Erreur lors de l'ajout du commentaire : \(error.localizedDescription)")
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
                                            .id(scrollToBottomKey)
                                            .padding(.bottom, paddingBottom)
                                    }
                                    .padding(.horizontal, 24)
                                }
                            }
                            .scrollIndicators(.hidden)
                            .scrollPosition($scrollPosition)
                            .animation(.spring, value: scrollPosition)
                            .onChange(of: isCommentTextfieldFocused) {
                                if isCommentTextfieldFocused {
                                    if UIDevice.current.model == "iPhone" && UIScreen.main.nativeBounds.height / UIScreen.main.scale <= 956 && UIScreen.main.nativeBounds.height / UIScreen.main.scale >= 780 {
                                        paddingBottom = 333
                                    } else if UIDevice.current.model == "iPhone" && UIScreen.main.nativeBounds.height / UIScreen.main.scale == 667 {
                                        paddingBottom = 260
                                    }
                                    scrollToBottomKey = UUID().uuidString
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            proxy.scrollTo(scrollToBottomKey, anchor: .bottom)
                                        }
                                    }
                                } else {
                                    withAnimation {
                                        paddingBottom = 0
                                    }
                                }
                            }
                        }
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
                                    
                                    let userId = currentUser.userId
                                    
                                    Task {
                                        do {
                                            try await apiPostManager.toggleBookmark(userId: userId, recipeId: recipeId, isBookmarked: isBookmarkSelected)
                                            isBookmarkSelected.toggle()
                                            if isBookmarkSelected {
                                                addedToBookmarks = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    addedToBookmarks = false
                                                }
                                            }
                                        } catch {
                                            print("Error bookmarking recipe")
                                        }
                                    }
                                } label: {
                                    Image(isBookmarkSelected ? "Bookmark - Regular - Bold" : "Bookmark - Regular - Light - Outline")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundStyle(Color(isBookmarkSelected ? "Primary900" : "MyWhite"))
                                }
                            }
                        }
                    }
                    .onAppear {
                        guard let currentUser = userSession.first else {
                            return
                        }
                        
                        let userId = currentUser.userId
                        
                        connectedUserId = userId
                        
                        if isSearch == true {
                            Task {
                                do {
                                    _ = try await apiPostManager.incrementRecipeSearch(recipeId: recipeId)
                                } catch {
                                    print("Failed to increment search")
                                }
                            }
                        }
                        
                        Task {
                            do {
                                let isFollowing = try await apiGetManager.isFollowing(followerId: userId, followedId: recipeDetails.userId)
                                print("is following : \(isFollowing)")
                                print("follower \(userId) followed \(recipeDetails.userId)")
                                if isFollowing {
                                    following = true
                                } else {
                                    following = false
                                }
                            }
                        }
                        
                        Task {
                            async let isBookmarked = try await apiGetManager.getBookmark(userId: userId, recipeId: recipeDetails.id)
                            async let recipeDetails = try await apiGetManager.getRecipeDetails(recipeId: recipeId)
                            async let user = try await apiGetManager.getUserDataFromUserId(userId: userId)
                            async let comments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
                            async let _ = try await apiPostManager.incrementViews(recipeId: recipeId)
                            
                            do {
                                if try await isBookmarked {
                                    isBookmarkSelected = true
                                }
                                self.recipeDetails = try await recipeDetails
                                self.profilePictureUrl = try await user.profilePictureUrl ?? ""
                                self.comments = try await comments
                            } catch {
                                print("Failed to load data")
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
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(LinearGradient(gradient: Gradient(colors: [Color(red: 0.96, green: 0.28, blue: 0.29, opacity: 1), Color(red: 1, green: 0.45, blue: 0.46, opacity: 1)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        }
                        
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
    RecipeDetailsView(recipeId: 1, isSearch: false)
}
