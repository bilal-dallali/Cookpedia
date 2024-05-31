//
//  ProfilePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 12/04/2023.
//

import SwiftUI

struct ProfilePageView: View {
    
    @State private var isRecipeSelected: Bool = false
    @State private var isAboutSelected: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("Profile")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .padding(.leading, 16)
                            Spacer()
                            Button {
                                //
                            } label: {
                                Image("send")
                            }

                            Button {
                                //
                            } label: {
                                Image("setting")
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.vertical, 10)
                        
                        VStack(spacing: 28) {
                            VStack(spacing: 16) {
                                HStack(spacing: 20) {
                                    Image("profile-picture")
                                        .resizable()
                                        .frame(width: 72, height: 72)
                                        .cornerRadius(.infinity)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Andrew Ainsley")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                        Text("@andrew_ainsley")
                                            .foregroundColor(Color("Greyscale700"))
                                            .font(.custom("Urbanist-Medium", size: 16))
                                    }
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image("edit")
                                            Text("Edit")
                                                .foregroundColor(Color("Primary"))
                                        }
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 6)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: .infinity)
                                                .stroke(Color("Primary"), lineWidth: 2)
                                        }
                                        
                                    }
                                }
                                Divider()
                                HStack {
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 4) {
                                            Text("125")
                                                .foregroundColor(Color("Greyscale900"))
                                                .font(.custom("Urbanist-Bold", size: 24))
                                            Text("recipes")
                                                .foregroundColor(Color("Greyscale700"))
                                                .font(.custom("Urbanist-Semibold", size: 12))
                                        }
                                        Spacer()
                                    }
                                    Divider()
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 4) {
                                            Text("104")
                                                .foregroundColor(Color("Greyscale900"))
                                                .font(.custom("Urbanist-Bold", size: 24))
                                            Text("following")
                                                .foregroundColor(Color("Greyscale700"))
                                                .font(.custom("Urbanist-Semibold", size: 12))
                                        }
                                        Spacer()
                                    }
                                    Divider()
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 4) {
                                            Text("5,278")
                                                .foregroundColor(Color("Greyscale900"))
                                                .font(.custom("Urbanist-Bold", size: 24))
                                            Text("followers")
                                                .foregroundColor(Color("Greyscale700"))
                                                .font(.custom("Urbanist-Semibold", size: 12))
                                        }
                                        Spacer()
                                    }
                                }
                                Divider()
                                
                                HStack(spacing: 0) {
                                    Button {
                                        isRecipeSelected = true
                                        isAboutSelected = false
                                    } label: {
                                        VStack(spacing: 12) {
                                            Text("Recipes")
                                                .foregroundColor(Color(isRecipeSelected ? "Primary" : "Greyscale500"))
                                                .font(.custom("Urbanist-Semibold", size: 18))
                                            Rectangle()
                                                .frame(height: 4)
                                                .frame(maxWidth: .infinity)
                                                .foregroundColor(Color(isRecipeSelected ? "Primary" : "Greyscale200"))
                                                .cornerRadius(.infinity)
                                        }
                                    }
                                    
                                    Button {
                                        isRecipeSelected = false
                                        isAboutSelected = true
                                    } label: {
                                        VStack(spacing: 12) {
                                            Text("About")
                                                .foregroundColor(Color(isAboutSelected ? "Primary" : "Greyscale500"))
                                                .font(.custom("Urbanist-Semibold", size: 18))
                                            Rectangle()
                                                .frame(height: 4)
                                                .frame(maxWidth: .infinity)
                                                .foregroundColor(Color(isAboutSelected ? "Primary" : "Greyscale200"))
                                                .cornerRadius(.infinity)
                                        }
                                    }
                                }
                            }
                            if isRecipeSelected {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack(spacing: 16) {
                                        RecipeCardView(title: "Vegetable Fruit Salad Simple Rec...", image: "vegetable-fruit-salad")
                                        RecipeCardView(title: "Vegetable, Fruit and Meat Salad", image: "vegetables-fruit-meat-salad")
                                    }
                                    
                                    HStack(spacing: 16) {
                                        RecipeCardView(title: "Sweet and Spicy Beef Soup Recipe", image: "sweet-spicy-beef-soup")
                                        RecipeCardView(title: "Chicken Noodles with Vegetables ...", image: "chicken-noodes-vegetables")
                                    }
                                }
                            } else if isAboutSelected {
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Description")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 18))
                                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                                            .foregroundColor(Color("Greyscale800"))
                                            .font(.custom("Urbanist-Medium", size: 16))
                                    }
                                    Divider()
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Social Media")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 18))
                                        HStack(spacing: 12) {
                                            Image("whatsapp")
                                            Text("WhatsApp")
                                                .foregroundColor(Color("Primary"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                        HStack(spacing: 12) {
                                            Image("facebook")
                                            Text("Facebook")
                                                .foregroundColor(Color("Primary"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                        HStack(spacing: 12) {
                                            Image("twitter")
                                            Text("Twitter")
                                                .foregroundColor(Color("Primary"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                        HStack(spacing: 12) {
                                            Image("instagram")
                                            Text("Instagram")
                                                .foregroundColor(Color("Primary"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                    }
                                    Divider()
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 12) {
                                            Image("world-icon")
                                            Text("ww.exampledomain.com")
                                                .foregroundColor(Color("Primary"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                                .foregroundColor(Color("Primary"))
                                        }
                                        HStack(spacing: 12) {
                                            Image("location")
                                            Text("New York, United States")
                                                .foregroundColor(Color("Greyscale800"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                        HStack(spacing: 12) {
                                            Image("info-square")
                                            Text("Joined since Aug 24, 2020")
                                                .foregroundColor(Color("Greyscale800"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                        HStack(spacing: 12) {
                                            Image("chart")
                                            Text("2,368,756 views")
                                                .foregroundColor(Color("Greyscale800"))
                                                .font(.custom("Urbanist-Medium", size: 16))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
