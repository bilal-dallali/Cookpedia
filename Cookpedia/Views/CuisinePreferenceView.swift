//
//  CuisinePreferenceView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/03/2023.
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
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select your cuisines preferences 🥘")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Select your cuisines preferences for better recommendations, or you can skip it.")
                            .foregroundColor(Color("Greyscale900"))
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
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if salad == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            Button {
                                egg.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("egg")
                                    Text("Egg")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if egg == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                    
                                }
                            }
                            Button {
                                soup.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("soup")
                                    Text("Soup")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if soup == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
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
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if meat == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                    
                                }
                            }
                            Button {
                                chicken.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("chicken")
                                    Text("Chicken")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if chicken == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            Button {
                                seafood.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("seafood")
                                    Text("Seafood")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if seafood == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
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
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if burger == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            Button {
                                pizza.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("pizza")
                                    Text("Pizza")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if pizza == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            Button {
                                sushi.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("sushi")
                                    Text("Sushi")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if sushi == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
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
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if rice == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            Button {
                                bread.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("bread")
                                    Text("Bread")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if bread == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            Button {
                                fruit.toggle()
                            } label: {
                                VStack(spacing: 8) {
                                    Image("fruit")
                                    Text("Fruit")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .frame(height: 129)
                                .overlay {
                                    if fruit == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .padding(.top, 40)
            }
            
            HStack(spacing: 16) {
                NavigationLink {
                    DietaryPreferencesView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit)
                } label: {
                    Text("Skip")
                        .foregroundColor(Color("Primary"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("Primary50"))
                        .cornerRadius(.infinity)
                        .padding(.top, 24)
                        .padding(.bottom)
                }
                
                if salad == true || egg == true || soup == true || meat == true || chicken == true || seafood == true || burger == true || pizza == true || sushi == true || rice == true || bread == true || fruit == true {
                    NavigationLink {
                        DietaryPreferencesView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit)
                        //print("pays:", country)
                        //print("niveau:", level)
                    } label: {
                        Text("Continue")
                            .foregroundColor(Color("White"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Primary"))
                            .cornerRadius(.infinity)
                            .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 4, x: 4, y: 8)
                            .padding(.top, 24)
                            .padding(.bottom)
                    }
                } else {
                    Text("Continue")
                        .foregroundColor(Color("White"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .cornerRadius(.infinity)
                        .padding(.top, 24)
                        .padding(.bottom)
                }
            }
        }
        .padding(.horizontal, 24)
        .background(Color("White"))
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

struct CuisinePreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        CuisinePreferenceView(country: .constant("France"), level: .constant("Advanced"))
    }
}
