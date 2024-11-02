//
//  CuisinePreferenceView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/10/2024.
//

import SwiftUI

struct CuisinePreferenceView: View {
    
    @Binding var country: String
    @Binding var level: String
    @State var salad: Bool = false
    @State var egg: Bool = false
    @State var soup: Bool = false
    @State var meat: Bool = false
    @State var chicken: Bool = false
    @State var seafood: Bool = false
    @State var burger: Bool = false
    @State var pizza: Bool = false
    @State var sushi: Bool = false
    @State var rice: Bool = false
    @State var bread: Bool = false
    @State var fruit: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select your cuisines preferences 🥘")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Select your cuisines preferences for better recommendations, or you can skip it.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            Button {
                                salad.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("salad")
                                    Text("Salad")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if salad == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                egg.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("egg")
                                    Text("Egg")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if egg == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                soup.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("soup")
                                    Text("Soup")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if soup == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                meat.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("meat")
                                    Text("Meat")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if meat == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                chicken.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("chicken")
                                    Text("Chicken")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if chicken == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                seafood.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("seafood")
                                    Text("Seafood")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if seafood == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                burger.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("burger")
                                    Text("Burger")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if burger == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                pizza.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("pizza")
                                    Text("Pizza")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if pizza == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                sushi.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("sushi")
                                    Text("Sushi")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if sushi == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            Button {
                                rice.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("rice")
                                    Text("Rice")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if rice == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                bread.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("bread")
                                    Text("Bread")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if bread == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                fruit.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("fruit")
                                    Text("Fruit")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .background(Color("Dark2"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay {
                                    if fruit == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Divider()
                .overlay {
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color("Dark4"))
                }
            
            VStack {
                HStack(spacing: 16) {
                    NavigationLink {
                        //DietaryPreferencesView()
                        DietaryPreferencesView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit)
                    } label: {
                        Text("Skip")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Dark4"))
                            .clipShape(.rect(cornerRadius: .infinity))
                    }
                    if salad == true || egg == true || soup == true || meat == true || chicken == true || seafood == true || burger == true || pizza == true || sushi == true || rice == true || bread == true || fruit == true {
                        NavigationLink {
                            //DietaryPreferencesView()
                            DietaryPreferencesView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit)
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
                .padding(.top, 24)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(height: 84)
            .frame(maxWidth: .infinity)
            .background(Color("Dark1"))
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-50")
            }
        }
    }
}

#Preview {
    CuisinePreferenceView(country: .constant("France"), level: .constant("Advanced"))
}
