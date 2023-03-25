//
//  CookingLevelView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 13/03/2023.
//

import SwiftUI

struct CookingLevelView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            NavigationLink(destination: WelcomeView()) {
                                Image("arrow-left")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color("Greyscale900"))
                                    .padding(.vertical, 10)
                            }
                            .padding(.trailing, 55)
                            Image("progress-bar-33")
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("What is your cooking level? 🍳")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 32))
                                Text("Please select your cooking level for a better recommendations.")
                                    .font(.custom("Urbanist-Regular", size: 18))
                            }
                            
                            
                            VStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Novice")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                        .padding(.bottom, 8)
                                        Spacer()
                                    }
                                    Text("Basic understanding of kitchen tools and basic cooking techniques such as boiling and frying.")
                                        .foregroundColor(Color("Greyscale700"))
                                        .font(.custom("Urbanist-regular", size: 16))
                                        
                                }
                                .padding(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Intermediate")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .padding(.bottom, 8)
                                        Spacer()
                                    }
                                    Text("Ability to follow recipes, prepare simple dishes, and basic knife skills.")
                                        .foregroundColor(Color("Greyscale700"))
                                        .font(.custom("Urbanist-regular", size: 16))
                                        
                                }
                                .padding(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Advanced")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .padding(.bottom, 8)
                                        Spacer()
                                    }
                                    Text("Understanding of cooking principles, create recipes, & proficiency in various cooking techniques such as baking, grilling, & roasting.")
                                        .foregroundColor(Color("Greyscale700"))
                                        .font(.custom("Urbanist-regular", size: 16))
                                        
                                }
                                .padding(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                                
                                VStack {
                                    HStack {
                                        Text("Professional")
                                            .foregroundColor(Color("Greyscale900"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                        .padding(.bottom, 8)
                                        Spacer()
                                    }
                                    Text("Extensive knowledge of cooking techniques and ingredients, ability to work in a fast-paced environment, and experience in a professional kitchen setting.")
                                        .foregroundColor(Color("Greyscale700"))
                                        .font(.custom("Urbanist-regular", size: 16))
                                }
                                .padding(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
                Button {
                    //
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .foregroundColor(Color("White"))
                            .frame(height: 58)
                            .font(.custom("Urbanist-Bold", size: 16))
                        Spacer()
                    }
                    .background(Color("DisButton"))
                    .cornerRadius(.infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom)
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CookingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        CookingLevelView()
    }
}
