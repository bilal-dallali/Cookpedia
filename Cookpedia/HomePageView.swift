//
//  HomePage.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 08/04/2023.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("Cookpedia")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .padding(.leading, 16)
                            Spacer()
                            Button {
                                //
                            } label: {
                                Image("notifications")
                            }

                            Button {
                                //
                            } label: {
                                Image("bookmark")
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        
                        VStack(alignment: .leading, spacing: 28) {
                            ZStack {
                                Image("read-more")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 160)
                                    .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                                HStack {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Learn how to become a master chef right now!")
                                            .foregroundColor(Color("White"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .lineSpacing(7)
                                        Button {
                                            //
                                        } label: {
                                            Text("Read more")
                                                .foregroundColor(Color("Primary"))
                                                .font(.custom("Urbanist-Semibold", size: 14))
                                        }
                                        .frame(width: 102, height: 32)
                                        .background(Color("White"))
                                        .cornerRadius(.infinity)
                                        
                                    }
                                    .frame(width: 220)
                                    .padding(.leading, 30)
                                    Spacer()
                                }
                            }
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Recent Recipes")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image("arrow-right")
                                    }
                                }
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        RecipeCardNameView(title: "Original Italian Pizza Recipe for ...", avatarImage: "jane-cooper", image: "original-pizza", name: "Jane Cooper")
                                        RecipeCardNameView(title: "Special Blueberry & Banana Sandw...", avatarImage: "rayford-chenail", image: "blueberry-banana-sandwich", name: "Rayford Chenail")
                                        RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "pancakes", name: "Jean-Philippe Hubert")
                                    }
                                }
                            }
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Your Recipes")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image("arrow-right")
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
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Your Bookmark")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 24))
                                    Spacer()
                                    Button {
                                        //
                                    } label: {
                                        Image("arrow-right")
                                    }
                                }
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        RecipeCardNameView(title: "Meat, Noodle and Seafood Recipes ...", avatarImage: "clinton-mcclure", image: "meat-noodles-recipe", name: "Clinton Mcclure")
                                        RecipeCardNameView(title: "Scrambled Eggs & French Bread ...", avatarImage: "charolette-hanlin", image: "scrambled-eggs", name: "Charolette Hanlin")
                                        RecipeCardNameView(title: "Your Recipes Title Write Here ...", avatarImage: "profile-picture", image: "egg-salad", name: "Jean-Philippe Hubert")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 16)
                }
            }
        }
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
