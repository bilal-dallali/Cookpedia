//
//  RecipeCardNameView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 31/10/2024.
//

import SwiftUI

struct RecipeCardNameView: View {
    
    var title: String
    var avatarImage: String
    var image: String
    var name: String
    @State private var isBookmarkSelected = false
    
    var body: some View {
        Button {
            print("pol")
        } label: {
            ZStack {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 183, height: 260)
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0), Color(red: 0.13, green: 0.13, blue: 0.13, opacity: 0.5), Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.8), Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 1), Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 1)]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
                    .frame(width: 183, height: 140)
                    .offset(y: 60)
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Button {
                            isBookmarkSelected.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 36, height: 36)
                                    .foregroundStyle(Color("Primary900"))
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29, opacity: 0.25), radius: 12, x: 4, y: 8)
                                Image(isBookmarkSelected ? "bookmark-selected" : "bookmark-unselected")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.top, 12)
                            .padding(.trailing, 12)
                        }
                        
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 18))
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 6) {
                            Image(avatarImage)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .clipShape(.rect(cornerRadius: .infinity))
                            Text(name)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-SemiBold", size: 10))
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)
                }
            }
            .frame(width: 183, height: 260)
            .clipShape(.rect(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Dark3"), lineWidth: 1)
            }
        }

    }
}

#Preview {
    RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "original-pizza", name: "Jane Cooper")
}
