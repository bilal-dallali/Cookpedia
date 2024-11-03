//
//  CookingLevelView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/10/2024.
//

import SwiftUI

struct CookingLevelView: View {
    
    @Binding var country: String
    @State var novice: Bool = false
    @State var intermediate: Bool = false
    @State var advanced: Bool = false
    @State var professional: Bool = false
    @State var master: Bool = false
    @State var level: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What is your cooking level? 🍳")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Please select your cooking level for a better recommendations.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Button {
                            novice = true
                            intermediate = false
                            advanced = false
                            professional = false
                            master = false
                            level = "Novice"
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Novice")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Basic understanding of kitchen tools and basic cooking techniques such as boiling and frying.")
                                    .foregroundStyle(Color("Greyscale300"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                if novice == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            novice = false
                            intermediate = true
                            advanced = false
                            professional = false
                            master = false
                            level = "Intermediate"
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Intermediate")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Ability to follow recipes, prepare simple dishes, and basic knife skills.")
                                    .foregroundStyle(Color("Greyscale300"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                if intermediate == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            novice = false
                            intermediate = false
                            advanced = true
                            professional = false
                            master = false
                            level = "Advanced"
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Advanced")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Understanding of cooking principles, create recipes, & proficiency in various cooking techniques such as baking, grilling, & roasting.")
                                    .foregroundStyle(Color("Greyscale300"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                if advanced == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            novice = false
                            intermediate = false
                            advanced = false
                            professional = true
                            master = false
                            level = "Professional"
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Professional")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Extensive knowledge of cooking techniques and ingredients, ability to work in a fast-paced environment, and experience in a professional kitchen setting.")
                                    .foregroundStyle(Color("Greyscale300"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                if professional == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            novice = false
                            intermediate = false
                            advanced = false
                            professional = false
                            master = true
                            level = "Master"
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Master")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Exceptional culinary skills, ability to create innovative dishes, and mastery of advanced cooking techniques.")
                                    .foregroundStyle(Color("Greyscale300"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                if master == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
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
                if level == "" {
                    Text("Continue")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .clipShape(.rect(cornerRadius: .infinity))
                } else {
                    NavigationLink {
                        CuisinePreferenceView(country: $country, level: $level)
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
                }
                Spacer()
            }
            .padding(.top, 24)
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
                Image("progress-bar-33")
            }
        }
    }
}

#Preview {
    CookingLevelView(country: .constant("France"))
}
