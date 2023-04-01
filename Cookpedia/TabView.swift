//
//  TabView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 31/03/2023.
//

import SwiftUI

struct TabView: View {
    
    @State private var isHomeSelected: Bool = false
    @State private var isDiscoverSelected: Bool = false
    @State private var isRecipeSelected: Bool = false
    @State private var isProfileSelected: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button {
                    isHomeSelected = true
                    isDiscoverSelected = false
                    isRecipeSelected = false
                    isProfileSelected = false
                } label: {
                    VStack(spacing: 2) {
                        Image(isHomeSelected ? "house-selected" : "house")
                        if isHomeSelected {
                            Text("Home")
                                .foregroundColor(Color("Primary"))
                                .font(.custom("Urbanist-Bold", size: 10))
                        } else {
                            Text("Home")
                                .foregroundColor(Color("Greyscale500"))
                                .font(.custom("Urbanist-Medium", size: 10))
                        }
                    }
                    .frame(width: 63, height: 38)
                }
                Spacer()
                Button {
                    isHomeSelected = false
                    isDiscoverSelected = true
                    isRecipeSelected = false
                    isProfileSelected = false
                } label: {
                    VStack(spacing: 2) {
                        Image(isDiscoverSelected ? "discover-selected" : "discover")
                        if isDiscoverSelected {
                            Text("Discover")
                                .foregroundColor(Color("Primary"))
                                .font(.custom("Urbanist-Bold", size: 10))
                        } else {
                            Text("Discover")
                                .foregroundColor(Color("Greyscale500"))
                                .font(.custom("Urbanist-Medium", size: 10))
                        }
                    }
                    .frame(width: 63, height: 38)
                }
                Spacer()
                Button {
                    //
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 38, height: 38)
                            .foregroundColor(Color("Primary"))
                            .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("White"))
                    }
                }
                .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                Spacer()
                Button {
                    isHomeSelected = false
                    isDiscoverSelected = false
                    isRecipeSelected = true
                    isProfileSelected = false
                } label: {
                    VStack(spacing: 2) {
                        Image(isRecipeSelected ? "recipe-selected" : "recipe")
                        if isRecipeSelected {
                            Text("Recipe")
                                .foregroundColor(Color("Primary"))
                                .font(.custom("Urbanist-Bold", size: 10))
                        } else {
                            Text("Recipe")
                                .foregroundColor(Color("Greyscale500"))
                                .font(.custom("Urbanist-Medium", size: 10))
                        }
                    }
                    .frame(width: 63, height: 38)
                }
                Spacer()
                Button {
                    isHomeSelected = false
                    isDiscoverSelected = false
                    isRecipeSelected = false
                    isProfileSelected = true
                } label: {
                    VStack(spacing: 2) {
                        Image(isProfileSelected ? "profile-selected" : "profile")
                        if isProfileSelected {
                            Text("Profile")
                                .foregroundColor(Color("Primary"))
                                .font(.custom("Urbanist-Bold", size: 10))
                        } else {
                            Text("Profile")
                                .foregroundColor(Color("Greyscale500"))
                                .font(.custom("Urbanist-Medium", size: 10))
                        }
                    }
                    .frame(width: 63, height: 38)
                }
            }
            .frame(height: 48)
            //.background(Color("Purple"))
            .padding(.bottom, 34)
            .padding(.horizontal, 32)
        }
        .frame(height: 90)
        //.background(Color("Lime"))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
            .previewLayout(.sizeThatFits)
            .frame(height: 90)
    }
}
