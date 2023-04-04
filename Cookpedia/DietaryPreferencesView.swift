//
//  DietaryPreferencesView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 27/03/2023.
//

import SwiftUI

struct DietaryPreferencesView: View {
    
    @State private var vegetarian: Bool = false
    @State private var vegan: Bool = false
    @State private var glutenFree: Bool = false
    @State private var nutFree: Bool = false
    @State private var dairyFree: Bool = false
    @State private var lowCarb: Bool = false
    @State private var peanutFree: Bool = false
    @State private var keto: Bool = false
    @State private var soyFree: Bool = false
    @State private var rawFood: Bool = false
    @State private var lowFat: Bool = false
    @State private var halal: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select your cuisines preferences 🥘")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Select your cuisines preferences for better recommendations, or you can skip it.")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
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
                                        .cornerRadius(8)
                                    Text("Vegetarian")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if vegetarian == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                vegan.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("vegan")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Vegan")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if vegan == false {
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
                                glutenFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("gluten-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Gluten-free")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if glutenFree == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                nutFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("nut-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Nut-free")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if nutFree == false {
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
                                dairyFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("dairy-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Dairy-free")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if dairyFree == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                lowCarb.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("low-carb")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Low-carb")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if lowCarb == false {
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
                                peanutFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("peanut-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Peanut-free")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if peanutFree == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                keto.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("keto")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Keto")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if keto == false {
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
                                soyFree.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("soy-free")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Soy-free")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if soyFree == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                rawFood.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("raw-food")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Raw food")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if rawFood == false {
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
                                lowFat.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("low-fat")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Low-fat")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if lowFat == false {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color("Primary"), lineWidth: 2)
                                    }
                                }
                            }
                            
                            Button {
                                halal.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    Image("halal")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                    Text("Halal")
                                        .lineLimit(1)
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 18))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .overlay {
                                    if halal == false {
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
                    CompleteProfileView()
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
                
                if vegetarian == true || vegan == true || glutenFree == true || nutFree == true || dairyFree == true || lowCarb == true || peanutFree == true || keto == true || soyFree == true || rawFood == true || lowFat == true || halal == true {
                    NavigationLink {
                        CompleteProfileView()
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
                Image("progress-bar-60")
            }
        }

    }
}

struct DietaryPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        DietaryPreferencesView()
    }
}
