//
//  TopChefSmallCardView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 06/01/2025.
//

import SwiftUI

struct TopChefSmallCardView: View {
    
    let user: UserDetails
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: "\(baseUrl)/users/profile-picture/\(user.profilePictureUrl ?? "").jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("Greyscale400"))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0), Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0.2), Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.6), Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 0.8), Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.9)]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 140)
                Text(user.fullName)
                    .foregroundStyle(Color("MyWhite"))
                    .font(.custom("Urbanist-Bold", size: 18))
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    TopChefSmallCardView(user: UserDetails(id: 1, username: "Georges", fullName: "Georges Dupont", profilePictureUrl: ""))
}
