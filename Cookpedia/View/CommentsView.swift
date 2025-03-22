//
//  CommentsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI
import SwiftData

struct CommentsView: View {
    
    let recipeId: Int
    @State private var errorMessage: String = ""
    @State private var displayErrorMessage: Bool = false
    @State private var isTopSelected: Bool = true
    @State private var isNewestSelected: Bool = false
    @State private var isOldestSelected: Bool = false
    @State private var commentText: String = ""
    @State private var refreshComment: Bool = false
    @FocusState private var isCommentTextfieldFocused: Bool
    @State private var profilePictureUrl: String = ""
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    
    @State private var topComments: [CommentsDetails] = []
    @State private var newestComments: [CommentsDetails] = []
    
    var apiGetManager = APIGetRequest()
    var apiPostManager = APIPostRequest()
    var apiDeleteManager = APIDeleteRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        isTopSelected = true
                        isNewestSelected = false
                        isOldestSelected = false
                    } label: {
                        if isTopSelected {
                            Text("Top")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        } else {
                            Text("Top")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                    }
                    
                    Button {
                        isTopSelected = false
                        isNewestSelected = true
                        isOldestSelected = false
                    } label: {
                        if isNewestSelected {
                            Text("Newest")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        } else {
                            Text("Newest")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                    }
                    
                    Button {
                        isTopSelected = false
                        isNewestSelected = false
                        isOldestSelected = true
                    } label: {
                        if isOldestSelected {
                            Text("Oldest")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        } else {
                            Text("Oldest")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(height: 38)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                    }
                }
                .padding(.top, 0)
                if isTopSelected {
                    ScrollView {
                        if displayErrorMessage {
                            Text(errorMessage)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 120)
                        } else {
                            VStack(spacing: 24) {
                                ForEach(topComments, id: \.id) { comment in
                                    CommentSlotView(comment: comment, refreshComment: $refreshComment)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 24)
                } else if isNewestSelected {
                    ScrollView {
                        if displayErrorMessage {
                            Text(errorMessage)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 120)
                        } else {
                            VStack(spacing: 24) {
                                ForEach(newestComments, id: \.id) { comment in
                                    CommentSlotView(comment: comment, refreshComment: $refreshComment)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 24)
                } else if isOldestSelected {
                    ScrollView {
                        if displayErrorMessage {
                            Text(errorMessage)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .frame(maxWidth: .infinity)
                                .padding(.top, 120)
                        } else {
                            VStack(spacing: 24) {
                                ForEach(newestComments.reversed(), id: \.id) { comment in
                                    CommentSlotView(comment: comment, refreshComment: $refreshComment)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 24)
                }
            }
            .padding(.horizontal, 24)
            VStack(spacing: 0) {
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color("Dark4"))
                    }
                VStack(spacing: 0) {
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
                                
                                CrashManager.shared.setUserId(userId: String(userId))
                                CrashManager.shared.addLog(message: "Submit comment")
                                
                                let comment = CommentsPost(userId: userId, recipeId: recipeId, comment: commentText)
                                
                                Task {
                                    do {
                                        _ = try await apiPostManager.postComment(comment: comment)
                                        commentText = ""
                                        
                                        Task {
                                            async let topComments = try await apiGetManager.getCommentsByLikes(forRecipeId: recipeId)
                                            async let newestComments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
                                            
                                            do {
                                                self.topComments = try await topComments
                                                self.newestComments = try await newestComments
                                            } catch let error as APIGetError {
                                                switch error {
                                                case .invalidUrl:
                                                    errorMessage = "The request URL is invalid. Please check your connection."
                                                case .invalidResponse:
                                                    errorMessage = "Unexpected response from the server. Try again later."
                                                case .decodingError:
                                                    errorMessage = "We couldn't process the data. Please update your app."
                                                case .serverError:
                                                    errorMessage = "The server is currently unavailable. Try again later."
                                                case .userNotFound:
                                                    errorMessage = "We couldn't find the user you're looking for."
                                                }
                                                displayErrorMessage = true
                                            } catch {
                                                errorMessage = "An unexpected error occurred. Please try again later."
                                                displayErrorMessage = true
                                            }
                                        }
                                    } catch let error as APIPostError {
                                        switch error {
                                        case .invalidUrl:
                                            errorMessage = "The request URL is invalid. Please check your connection."
                                        case .invalidResponse:
                                            errorMessage = "Unexpected response from the server. Try again later."
                                        case .decodingError:
                                            errorMessage = "We couldn't process the data. Please update your app."
                                        case .serverError:
                                            errorMessage = "The server is currently unavailable. Try again later."
                                        case .userNotFound:
                                            errorMessage = "We couldn't find the user you're looking for."
                                        case .invalidData:
                                            errorMessage = "The data you provided is invalid."
                                        case .invalidCredentials:
                                            errorMessage = "The credentials you provided are incorrect."
                                        case .emailAlreadyExists:
                                            errorMessage = "The email address you provided is already in use."
                                        case .usernameAlreadyExists:
                                            errorMessage = "The username you provided is already in use."
                                        case .phoneNumberAlreadyExists:
                                            errorMessage = "The phone number you provided is already in use."
                                        case .requestFailed:
                                            errorMessage = "We encountered an error processing your request."
                                        }
                                    }
                                }
                            }
                            Button {
                                guard let currentUser = userSession.first else {
                                    return
                                }
                                
                                let userId = currentUser.userId
                                
                                CrashManager.shared.setUserId(userId: String(userId))
                                CrashManager.shared.addLog(message: "Comment button tapped")
                                
                                let comment = CommentsPost(userId: userId, recipeId: recipeId, comment: commentText)
                                
                                Task {
                                    do {
                                        _ = try await apiPostManager.postComment(comment: comment)
                                        commentText = ""
                                        
                                        Task {
                                            async let topComments = try await apiGetManager.getCommentsByLikes(forRecipeId: recipeId)
                                            async let newestComments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
                                            
                                            do {
                                                self.topComments = try await topComments
                                                self.newestComments = try await newestComments
                                            } catch let error as APIGetError {
                                                switch error {
                                                case .invalidUrl:
                                                    errorMessage = "The request URL is invalid. Please check your connection."
                                                case .invalidResponse:
                                                    errorMessage = "Unexpected response from the server. Try again later."
                                                case .decodingError:
                                                    errorMessage = "We couldn't process the data. Please update your app."
                                                case .serverError:
                                                    errorMessage = "The server is currently unavailable. Try again later."
                                                case .userNotFound:
                                                    errorMessage = "We couldn't find the user you're looking for."
                                                }
                                                displayErrorMessage = true
                                            } catch {
                                                errorMessage = "An unexpected error occurred. Please try again later."
                                                displayErrorMessage = true
                                            }
                                        }
                                    } catch let error as APIPostError {
                                        switch error {
                                        case .invalidUrl:
                                            errorMessage = "The request URL is invalid. Please check your connection."
                                        case .invalidResponse:
                                            errorMessage = "Unexpected response from the server. Try again later."
                                        case .decodingError:
                                            errorMessage = "We couldn't process the data. Please update your app."
                                        case .serverError:
                                            errorMessage = "The server is currently unavailable. Try again later."
                                        case .userNotFound:
                                            errorMessage = "We couldn't find the user you're looking for."
                                        case .invalidData:
                                            errorMessage = "The data you provided is invalid."
                                        case .invalidCredentials:
                                            errorMessage = "The credentials you provided are incorrect."
                                        case .emailAlreadyExists:
                                            errorMessage = "The email address you provided is already in use."
                                        case .usernameAlreadyExists:
                                            errorMessage = "The username you provided is already in use."
                                        case .phoneNumberAlreadyExists:
                                            errorMessage = "The phone number you provided is already in use."
                                        case .requestFailed:
                                            errorMessage = "We encountered an error processing your request."
                                        }
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
                    .padding(.horizontal, 24)
                }
                .frame(height: 118)
                .frame(maxWidth: .infinity)
                
            }
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: isCommentTextfieldFocused == false ? .bottom : [])
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Comments (\(newestComments.count))")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                        .padding(.leading, 16)
                    Spacer()
                }
            }
        }
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "view_comment_page")
        }
        .task {
            guard let currentUser = userSession.first else {
                return
            }
            
            let userId = currentUser.userId
            
            CrashManager.shared.setUserId(userId: String(userId))
            CrashManager.shared.addLog(message: "Display comments")
            
            do {
                
                let user = try await apiGetManager.getUserDataFromUserId(userId: userId)
                
                DispatchQueue.main.async {
                    self.profilePictureUrl = user.profilePictureUrl ?? ""
                }
                topComments = try await apiGetManager.getCommentsByLikes(forRecipeId: recipeId)
                newestComments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
            } catch let error as APIGetError {
                switch error {
                case .invalidUrl:
                    errorMessage = "The request URL is invalid. Please check your connection."
                case .invalidResponse:
                    errorMessage = "Unexpected response from the server. Try again later."
                case .decodingError:
                    errorMessage = "We couldn't process the data. Please update your app."
                case .serverError:
                    errorMessage = "The server is currently unavailable. Try again later."
                case .userNotFound:
                    errorMessage = "We couldn't find the user you're looking for."
                }
                displayErrorMessage = true
            } catch {
                errorMessage = "An unexpected error occurred. Please try again later."
                displayErrorMessage = true
            }
        }
        .onChange(of: refreshComment) {
            Task {
                async let topComments = try await apiGetManager.getCommentsByLikes(forRecipeId: recipeId)
                async let newestComments = try await apiGetManager.getCommentsOrderDesc(forRecipeId: recipeId)
                
                do {
                    self.topComments = try await topComments
                    self.newestComments = try await newestComments
                } catch let error as APIGetError {
                    switch error {
                    case .invalidUrl:
                        errorMessage = "The request URL is invalid. Please check your connection."
                    case .invalidResponse:
                        errorMessage = "Unexpected response from the server. Try again later."
                    case .decodingError:
                        errorMessage = "We couldn't process the data. Please update your app."
                    case .serverError:
                        errorMessage = "The server is currently unavailable. Try again later."
                    case .userNotFound:
                        errorMessage = "We couldn't find the user you're looking for."
                    }
                    displayErrorMessage = true
                } catch {
                    errorMessage = "An unexpected error occurred. Please try again later."
                    displayErrorMessage = true
                }
            }
        }
        .onTapGesture {
            isCommentTextfieldFocused = false
        }
    }
}

#Preview {
    CommentsView(recipeId: 1)
}
