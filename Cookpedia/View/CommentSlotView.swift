//
//  CommentSlotView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 01/01/2025.
//

import SwiftUI

struct CommentSlotView: View {
    
    @State private var isCommentLiked: Bool = false
    
    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 16) {
                Image("tanner-stafford")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                Text("Tanner Stafford")
                    .foregroundStyle(Color("MyWhite"))
                    .font(.custom("Urbanist-Bold", size: 16))
                Spacer()
                Button {
                    //
                } label: {
                    Image("More Circle - Regular - Light - Outline")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color("MyWhite"))
                }
            }
            Text("Loving this recipe! So many delicious recipes to choose from ❤️❤️❤️")
                .foregroundStyle(Color("Greyscale50"))
                .font(.custom("Urbanist-Medium", size: 16))
            HStack(spacing: 24) {
                HStack(spacing: 8) {
                    Button {
                        withAnimation {
                            isCommentLiked.toggle()
                        }
                    } label: {
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
                            }
                        } else {
                            Image("Heart - Regular - Light - Outline")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color("Greyscale300"))
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
        }
    }
}

#Preview {
    CommentSlotView()
}
