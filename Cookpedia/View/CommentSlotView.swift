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
    @Binding var deleteCommentAlert: Bool
    var apiPostManager = APIPostRequest()
    var apiGetManager = APIGetRequest()
    var apiDeleteManager = APIDeleteRequest()
    @Environment(\.modelContext) var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    
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
                            Image("tanner-stafford")
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
                                    .foregroundStyle(Color("Primary900"))
                            } icon: {
                                Image("Delete - Regular - Light - Outline")
                                    .foregroundStyle(Color("Primary900"))
                            }
                        }
                    } else {
                        Button {
                            //
                        } label: {
                            Text("Can't delete the comment it's not yours")
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
                        isCommentLiked.toggle()
                        if isCommentLiked {
                            withAnimation(.easeIn(duration: 0.4)) {
                                heartScaleX = 1
                                heartScaleY = 1
                            }
                        } else {
                            withAnimation(.easeOut(duration: 0.4)) {
                                heartScaleX = 0
                                heartScaleY = 0
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
                    Text("90")
                        .foregroundStyle(Color("Greyscale300"))
                        .font(.custom("Urbanist-Medium", size: 12))
                }
                Text("1 month ago")
                    .foregroundStyle(Color("Greyscale300"))
                    .font(.custom("Urbanist-Medium", size: 12))
                Spacer()
            }
            .frame(height: 24)
        }
        .onAppear {
            guard let currentUser = userSession.first else {
                return
            }
            
            guard let connectedUserId = Int(currentUser.userId) else {
                return
            }
            
            userId = connectedUserId
        }
    }
}

#Preview {
    CommentSlotView(comment: CommentsDetails(id: 1, userId: 1, recipeId: 8, comment: "Amazing recipe", fullName: "Tanner Stafford", profilePictureUrl: "anyway", createdAt: "2025-01-01 22:05:17"), deleteCommentAlert: .constant(false))
}
