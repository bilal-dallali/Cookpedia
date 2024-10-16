//
//  RecipePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 12/04/2023.
//

import SwiftUI

struct RecipePageView: View {
    
    @State private var isDraftSelected: Bool = false
    @State private var isPublishedSelected: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("My Recipes")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .padding(.leading, 16)
                            Spacer()
                            Button {
                                //
                            } label: {
                                Image("search-icon")
                            }
                            
                            Button {
                                //
                            } label: {
                                Image("more-circle")
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 28) {
                                HStack(spacing: 0) {
                                    Button {
                                        isDraftSelected = true
                                        isPublishedSelected = false
                                    } label: {
                                        VStack(spacing: 12) {
                                            Text("Draft (24)")
                                                .foregroundColor(Color(isDraftSelected ? "Primary" : "Greyscale500"))
                                                .font(.custom("Urbanist-Semibold", size: 18))
                                            Rectangle()
                                                .frame(height: 4)
                                                .frame(maxWidth: .infinity)
                                                .foregroundColor(Color(isDraftSelected ? "Primary" : "Greyscale200"))
                                                .cornerRadius(.infinity)
                                        }
                                    }
                                    
                                    Button {
                                        isDraftSelected = false
                                        isPublishedSelected = true
                                    } label: {
                                        VStack(spacing: 12) {
                                            Text("Published (125)")
                                                .foregroundColor(Color(isPublishedSelected ? "Primary" : "Greyscale500"))
                                                .font(.custom("Urbanist-Semibold", size: 18))
                                            Rectangle()
                                                .frame(height: 4)
                                                .frame(maxWidth: .infinity)
                                                .foregroundColor(Color(isPublishedSelected ? "Primary" : "Greyscale200"))
                                                .cornerRadius(.infinity)
                                        }
                                    }
                                }
                            
                            if isPublishedSelected {
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        MyRecipeCardView(title: "Vegetable Fruit Salad Simple Recipe", image: "vegetable-fruit-salad")
                                        MyRecipeCardView(title: "Vegetable, Fruit and Meat Salad", image: "vegetable-fruit-meat-salad")
                                    }
                                    HStack(spacing: 16) {
                                        MyRecipeCardView(title: "Sweet and Spicy Beef Soup Recipe", image: "sweet-spicy-beef-soup-recipe")
                                        MyRecipeCardView(title: "Chicken Noodles with Vegetables ...", image: "chicken-noodles-vegetables")
                                    }
                                    HStack(spacing: 16) {
                                        MyRecipeCardView(title: "Special Birthday Cake for Kids", image: "special-birthday-cake-kids")
                                        MyRecipeCardView(title: "Spinach, Tomato and Egg Salad w...", image: "spinach-tomato-egg-salad")
                                    }
                                }
                            } else if isDraftSelected {
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        MyRecipeCardView(title: "Vegetable Fruit Salad Simple Recipe", image: "vegetable-fruit-salad")
                                        MyRecipeCardView(title: "Original Burger & Special French Fries", image: "original-burger")
                                    }
                                    HStack(spacing: 16) {
                                        MyRecipeCardView(title: "Seasoned Fried Shrimp Seafood", image: "fried-shrimp")
                                        MyRecipeCardView(title: "Tuna, Salmon and Sour Vinegar Sushi", image: "tuna-salmon-sour-vinegar")
                                    }
                                    HStack(spacing: 16) {
                                        MyRecipeCardView(title: "Special Birthday Cake for Kids", image: "special-birthday-cake")
                                        MyRecipeCardView(title: "Sweet Sour Seasoned Grilled ...", image: "sweet-sour")
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 16)
                }
                .background(Color("White"))
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct RecipePageView_Previews: PreviewProvider {
    static var previews: some View {
        RecipePageView()
    }
}
