//
//  HomePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/10/2024.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 0) {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("Cookpedia")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .padding(.leading, 16)
                            Spacer()
                            
                            Button {
                                //
                            } label: {
                                Image("notifications")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            .padding(.trailing, 20)
                            
                            Button {
                                //
                            } label: {
                                Image("bookmark-unselected")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }

                        }
                        .padding(.vertical, 5)
                        
                        VStack(alignment: .leading, spacing: 28) {
                            ZStack {
                                Image("read-more")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                HStack {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Learn how to become a master chef right now!")
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .lineSpacing(7)
                                        Button {
                                            print("test123")
                                        } label: {
                                            Text("Read more")
                                                .foregroundStyle(Color("Primary900"))
                                                .font(.custom("Urbanist-Semibold", size: 14))
                                        }
                                        .frame(width: 102, height: 32)
                                        .background(Color("MyWhite"))
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                        
                                    }
                                    .frame(width: 220)
                                    .padding(.leading, 30)
                                    Spacer()
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Recent Recipes")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image("arrow-right")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }

                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        RecipeCardNameView(title: "Vegetable & Fruit Vegetarian Recip...", avatarImage: "tanner-stafford", image: "vegetable-and-fruit", name: "Tanner Stafford")
                                        RecipeCardNameView(title: "Delicious & Easy Mexican Taco Re...", avatarImage: "lauralee-quintero", image: "mexican-taco", name: "Lauralee Qintero")
                                        RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "vegetable-salad", name: "Jean-Philippe Hubert")
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Your Recipes")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image("arrow-right")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }

                                }
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        RecipeCardNameView(title: "Vegetable & Fruit Vegetarian Recip...", avatarImage: "tanner-stafford", image: "vegetable-and-fruit", name: "Tanner Stafford")
                                        RecipeCardNameView(title: "Delicious & Easy Mexican Taco Re...", avatarImage: "lauralee-quintero", image: "mexican-taco", name: "Lauralee Qintero")
                                        RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "vegetable-salad", name: "Jean-Philippe Hubert")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                .background(Color("Dark1"))
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    HomePageView()
}
