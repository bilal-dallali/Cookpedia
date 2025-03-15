//
//  CommentSlotView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 01/01/2025.
//

import SwiftUI
import SwiftData

struct CommentSlotView: View {
    
    let comment: CommentsDetails
    @State private var heartScaleX: CGFloat = 0
    @State private var heartScaleY: CGFloat = 0
    @State private var isCommentLiked: Bool = false
    @State private var userId: Int?
    @State private var deleteCommentAlert: Bool = false
    @State private var errorMessage: String = ""
    var apiPostManager = APIPostRequest()
    var apiGetManager = APIGetRequest()
    var apiDeleteManager = APIDeleteRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @Binding var refreshComment: Bool
    @State private var likeCount: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 0) {
                NavigationLink {
                    ProfilePageView(userId: comment.userId)
                } label: {
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(comment.profilePictureUrl).jpg")) { image in
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
                        Text(comment.fullName)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                    }
                }
                Spacer()
                Menu {
                    if userId == comment.userId {
                        Button {
                            deleteCommentAlert = true
                        } label: {
                            Label {
                                Text("Delete Comment")
                            } icon: {
                                Image("Delete - Regular - Light - Outline")
                            }
                        }
                        Button {
                            //
                        } label: {
                            Label {
                                Text("Signal as inappropriate")
                            } icon: {
                                Image("Danger Triangle - Regular - Light - Outline")
                            }
                        }
                    } else {
                        Button {
                            //
                        } label: {
                            Label {
                                Text("Signal as inappropriate")
                            } icon: {
                                Image("Danger Triangle - Regular - Light - Outline")
                            }
                        }
                    }
                } label: {
                    Image("More Circle - Regular - Light - Outline")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color("MyWhite"))
                }
            }
            Text(comment.comment)
                .foregroundStyle(Color("Greyscale50"))
                .font(.custom("Urbanist-Medium", size: 16))
            HStack(spacing: 24) {
                HStack(spacing: 8) {
                    Button {
                        if isCommentLiked == true {
                            Task {
                                do {
                                    let _ = try await apiDeleteManager.unlikeComment(userId: userId ?? 0, commentId: comment.id)
                                    DispatchQueue.main.async {
                                        likeCount -= 1
                                        isCommentLiked = false
                                        withAnimation(.easeIn(duration: 0.4)) {
                                            heartScaleX = 0
                                            heartScaleY = 0
                                        }
                                    }
                                }
                            }
                        } else if isCommentLiked == false {
                            Task {
                                do {
                                    try await apiPostManager.likeComment(userId: userId ?? 0, commentId: comment.id)
                                    DispatchQueue.main.async {
                                        likeCount += 1
                                        isCommentLiked = true
                                        withAnimation(.easeIn(duration: 0.4)) {
                                            heartScaleX = 1
                                            heartScaleY = 1
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
                    } label: {
                        ZStack {
                            if isCommentLiked {
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.96, green: 0.28, blue: 0.29), location: 0.00),
                                        Gradient.Stop(color: Color(red: 1, green: 0.45, blue: 0.46), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 1, y: 1),
                                    endPoint: UnitPoint(x: 0, y: 0)
                                )
                                .frame(width: 24, height: 24)
                                .mask {
                                    Image("Heart - Regular - Bold")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .scaleEffect(x: heartScaleX, y: heartScaleY, anchor: .center)
                                }
                            } else {
                                Image("Heart - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color("Greyscale300"))
                            }
                        }
                    }
                    Text("\(likeCount)")
                        .foregroundStyle(Color("Greyscale300"))
                        .font(.custom("Urbanist-Medium", size: 12))
                }
                Text("\(timeAgo(from: comment.createdAt))")
                    .foregroundStyle(Color("Greyscale300"))
                    .font(.custom("Urbanist-Medium", size: 12))
                Spacer()
            }
            .frame(height: 24)
        }
        .alert("", isPresented: $deleteCommentAlert) {
            Button("Cancel", role: .cancel) {
                
            }
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        let _ = try await apiDeleteManager.deleteComment(commentId: comment.id)
                        DispatchQueue.main.async {
                            refreshComment.toggle()
                        }
                    } catch let error as APIDeleteError {
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
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete this comment?")
                .foregroundStyle(Color("Primary900"))
                .font(.custom("Urbanist-Regular", size: 16))
        }
        .onAppear {
            guard let currentUser = userSession.first else {
                return
            }
            
            let connectedUserId = currentUser.userId
            
            userId = connectedUserId
            
            Task {
                do {
                    let count = try await apiGetManager.getCommentLikes(commentId: comment.id)
                    DispatchQueue.main.async {
                        likeCount = count
                    }
                } catch {
                    DispatchQueue.main.async {
                        likeCount = 0
                    }
                }
            }
            
            Task {
                do {
                    let isLiked = try await apiGetManager.isCommentLiked(userId: userId ?? 0, commentId: comment.id)
                    DispatchQueue.main.async {
                        isCommentLiked = isLiked
                        if isCommentLiked == true {
                            DispatchQueue.main.async {
                                withAnimation(.easeIn(duration: 0.4)) {
                                    heartScaleX = 1
                                    heartScaleY = 1
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                withAnimation(.easeIn(duration: 0.4)) {
                                    heartScaleX = 0
                                    heartScaleY = 0
                                }
                            }
                        }
                    }
                } catch {
                    isCommentLiked = false
                }
            }
        }
    }
}

#Preview {
    CommentSlotView(comment: CommentsDetails(id: 1, userId: 1, recipeId: 8, comment: "Amazing recipe", fullName: "Tanner Stafford", profilePictureUrl: "anyway", createdAt: "2025-01-01 22:05:17"), refreshComment: .constant(false))
}
