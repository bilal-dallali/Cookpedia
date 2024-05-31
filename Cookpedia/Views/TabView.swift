//
//  TabView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 31/03/2023.
//

import SwiftUI

struct TabView: View {
    
    @State private var isHomeSelected: Bool = true
    @State private var isDiscoverSelected: Bool = false
    @State private var isRecipeSelected: Bool = false
    @State private var isProfileSelected: Bool = false
    
    var body: some View {
        ZStack {
            if isHomeSelected {
                HomePageView()
            } else if isDiscoverSelected {
                DiscoverPageView()
            } else if isRecipeSelected {
                RecipePageView()
            } else if isProfileSelected {
                ProfilePageView()
            }
            VStack {
                Spacer()
                HStack {
                    Button {
                        isHomeSelected = true
                        isDiscoverSelected = false
                        isRecipeSelected = false
                        isProfileSelected = false
                    } label: {
                        VStack(spacing: 2) {
                            Image(isHomeSelected ? "house-selected" : "house")
                            Text("Home")
                                .foregroundColor(Color(isHomeSelected ? "Primary" : "Greyscale500"))
                                .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Regular", size: 10))
                        }
                    }
                    .frame(width: 63)
                    Spacer()
                    Button {
                        isHomeSelected = false
                        isDiscoverSelected = true
                        isRecipeSelected = false
                        isProfileSelected = false
                    } label: {
                        VStack(spacing: 2) {
                            Image(isDiscoverSelected ? "discover-selected" : "discover")
                            Text("Discover")
                                .foregroundColor(Color(isDiscoverSelected ? "Primary" : "Greyscale500"))
                                .font(.custom(isDiscoverSelected ? "Urbanist-Bold" : "Urbanist-Regular", size: 10))
                        }
                    }
                    .frame(width: 63)
                    Spacer()
                    
                    Button {
                        //
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("Primary"))
                                .frame(width: 38, height: 38)
                                .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                            Image(systemName: "plus")
                                .foregroundColor(Color("White"))
                                .frame(width: 12, height: 12)
                        }
                        .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                    }

                    
                    Spacer()
                    Button {
                        isHomeSelected = false
                        isDiscoverSelected = false
                        isRecipeSelected = true
                        isProfileSelected = false
                    } label: {
                        VStack(spacing: 2) {
                            Image(isRecipeSelected ? "recipe-selected" : "recipe")
                            Text("My Recipes")
                                .foregroundColor(Color(isRecipeSelected ? "Primary" : "Greyscale500"))
                                .font(.custom(isRecipeSelected ? "Urbanist-Bold" : "Urbanist-Regular", size: 10))
                        }
                    }
                    .frame(width: 63)
                    Spacer()
                    Button {
                        isHomeSelected = false
                        isDiscoverSelected = false
                        isRecipeSelected = false
                        isProfileSelected = true
                    } label: {
                        VStack(spacing: 2) {
                            Image(isProfileSelected ? "profile-selected" : "profile")
                            Text("Profile")
                                .foregroundColor(Color(isProfileSelected ? "Primary" : "Greyscale500"))
                                .font(.custom(isProfileSelected ? "Urbanist-Bold" : "Urbanist-Regular", size: 10))
                        }
                    }
                    .frame(width: 63)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .padding(.bottom, 34)
                .padding(.horizontal, 32)
                .background(Color("White"))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
