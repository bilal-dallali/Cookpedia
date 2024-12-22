//
//  TabView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI
import SwiftData

struct TabView: View {
    
    @State private var isHomeSelected: Bool = true
    @State private var isDiscoverSelected: Bool = false
    @State private var isMyRecipeSelected: Bool = false
    @State private var isMyProfileSelected: Bool = false
    
    @State private var isDraftSelected: Bool = true
    @State private var isPublishedSelected: Bool = false
    
    @State var isCreateRecipeSelected: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if isHomeSelected {
                HomePageView(isHomeSelected: $isHomeSelected, isDiscoverSelected: $isDiscoverSelected, isMyRecipeSelected: $isMyRecipeSelected, isMyProfileSelected: $isMyProfileSelected)
            } else if isDiscoverSelected {
                DiscoverPageView()
            } else if isMyRecipeSelected {
                MyRecipePageView()
            } else if isMyProfileSelected {
                MyProfilePageView(isHomeSelected: $isHomeSelected, isDiscoverSelected: $isDiscoverSelected, isMyRecipeSelected: $isMyRecipeSelected, isMyProfileSelected: $isMyProfileSelected)
            }
            VStack {
                HStack(alignment: .top) {
                    HStack(spacing: 19) {
                        Button {
                            isHomeSelected = true
                            isDiscoverSelected = false
                            isMyRecipeSelected = false
                            isMyProfileSelected = false
                        } label: {
                            VStack(spacing: 2) {
                                Image(isHomeSelected ? "Home - Regular - Bold" : "Home - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                Text("Home")
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                        }
                        
                        Button {
                            isHomeSelected = false
                            isDiscoverSelected = true
                            isMyRecipeSelected = false
                            isMyProfileSelected = false
                        } label: {
                            VStack(spacing: 2) {
                                Image(isDiscoverSelected ? "Discovery - Regular - Bold" : "Discovery - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(isDiscoverSelected ? "Primary900" : "Greyscale500"))
                                Text("Discover")
                                    .foregroundStyle(Color(isDiscoverSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isDiscoverSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                        }
                        
                        Button {
                            isCreateRecipeSelected = true
                        } label: {
                            Circle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(width: 38, height: 38)
                                .overlay {
                                    Image("Icon=plus, Component=Additional Icons")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundStyle(Color("MyWhite"))
                                        .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29, opacity: 0.25), radius: 12, x: 4, y: 8)
                                }
                        }

                        
                        Button {
                            isHomeSelected = false
                            isDiscoverSelected = false
                            isMyRecipeSelected = true
                            isMyProfileSelected = false
                        } label: {
                            VStack(spacing: 2) {
                                Image(isMyRecipeSelected ? "Paper - Regular - Bold" : "Paper - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(isMyRecipeSelected ? "Primary900" : "Greyscale500"))
                                Text("My Recipes")
                                    .foregroundStyle(Color(isMyRecipeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isMyRecipeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                        }
                        
                        Button {
                            isHomeSelected = false
                            isDiscoverSelected = false
                            isMyRecipeSelected = false
                            isMyProfileSelected = true
                        } label: {
                            VStack(spacing: 2) {
                                Image(isMyProfileSelected ? "Profile - Regular - Bold" : "Profile - Regular - Light - Outline")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(isMyProfileSelected ? "Primary900" : "Greyscale500"))
                                Text("Profile")
                                    .foregroundStyle(Color(isMyProfileSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isMyProfileSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                        }

                    }
                    .padding(.horizontal, 32)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                Spacer()
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background {
                Rectangle()
                    .foregroundStyle(Color(red: 0.09, green: 0.1, blue: 0.13).opacity(0.85))
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $isCreateRecipeSelected) {
            CreateRecipeView(isHomeSelected: $isHomeSelected, isDiscoverSelected: $isDiscoverSelected, isMyRecipeSelected: $isMyRecipeSelected, isMyProfileSelected: $isMyProfileSelected, isDraftSelected: .constant(true), isPublishedSelected: .constant(false), isCreateRecipeSelected: $isCreateRecipeSelected)
        }
    }
}

#Preview {
    TabView()
}
