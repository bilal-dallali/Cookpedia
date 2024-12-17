//
//  DietaryPreferencesView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/10/2024.
//

import SwiftUI

struct DietaryPreferencesView: View {
    
    @Binding var country: String
    @Binding var level: String
    @Binding var salad: Bool
    @Binding var egg: Bool
    @Binding var soup: Bool
    @Binding var meat: Bool
    @Binding var chicken: Bool
    @Binding var seafood: Bool
    @Binding var burger: Bool
    @Binding var pizza: Bool
    @Binding var sushi: Bool
    @Binding var rice: Bool
    @Binding var bread: Bool
    @Binding var fruit: Bool
    
    @State var vegetarian: Bool = false
    @State var vegan: Bool = false
    @State var glutenFree: Bool = false
    @State var nutFree: Bool = false
    @State var dairyFree: Bool = false
    @State var lowCarb: Bool = false
    @State var peanutFree: Bool = false
    @State var keto: Bool = false
    @State var soyFree: Bool = false
    @State var rawFood: Bool = false
    @State var lowFat: Bool = false
    @State var halal: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Do you have any dietary preferences? ⚙️")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Select your dietary preferences for better recommendations, or you can skip it.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-regular", size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 16) {
                            Button {
                                vegetarian.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("vegetarian")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Vegetarian")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(vegetarian ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                            
                            Button {
                                vegan.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("vegan")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Vegan")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(vegan ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                glutenFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("gluten-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Gluten-free")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(glutenFree ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                            
                            Button {
                                nutFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("nut-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Nut-free")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(nutFree ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                dairyFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("dairy-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Dairy-free")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(dairyFree ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                            
                            Button {
                                lowCarb.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("low-carb")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Low-carb")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(lowCarb ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                peanutFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("peanut-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Peanut-free")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(peanutFree ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                            
                            Button {
                                keto.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("keto")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Keto")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(keto ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                soyFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("soy-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Soy-free")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(soyFree ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                            
                            Button {
                                rawFood.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("raw-food")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Raw food")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(rawFood ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                lowFat.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("low-fat")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Low-fat")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(lowFat ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                            
                            Button {
                                halal.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("halal")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Text("Halal")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color(halal ? "Primary900" : "Dark4"), lineWidth: 1)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
            
            VStack(spacing: 0) {
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color("Dark4"))
                    }
                HStack(spacing: 16) {
                    NavigationLink {
                        CompleteProfileView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit, vegetarian: $vegetarian, vegan: $vegan, glutenFree: $glutenFree, nutFree: $nutFree, dairyFree: $dairyFree, lowCarb: $lowCarb, peanutFree: $peanutFree, keto: $keto, soyFree: $soyFree, rawFood: $rawFood, lowFat: $lowFat, halal: $halal)
                    } label: {
                        Text("Skip")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Dark4"))
                            .clipShape(.rect(cornerRadius: .infinity))
                    }
                    
                    
                    if vegetarian == true || vegan == true || glutenFree == true || nutFree == true || dairyFree == true || lowCarb == true || peanutFree == true || keto == true || soyFree == true || rawFood == true || lowFat == true || halal == true {
                        NavigationLink {
                            CompleteProfileView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit, vegetarian: $vegetarian, vegan: $vegan, glutenFree: $glutenFree, nutFree: $nutFree, dairyFree: $dairyFree, lowCarb: $lowCarb, peanutFree: $peanutFree, keto: $keto, soyFree: $soyFree, rawFood: $rawFood, lowFat: $lowFat, halal: $halal)
                        } label: {
                            Text("Continue")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(Color("Primary900"))
                                .clipShape(.rect(cornerRadius: .infinity))
                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                        }
                    } else {
                        Text("Continue")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("DisabledButton"))
                            .clipShape(.rect(cornerRadius: .infinity))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 36)
            }
        }
        .background(Color("Dark1"))
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-60")
            }
        }
    }
}

#Preview {
    DietaryPreferencesView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false))
}
