//
//  CookingLevelView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 13/03/2023.
//

import SwiftUI

struct CookingLevelView: View {
    
    @State var novice: Bool = false
    @State var intermediate: Bool = false
    @State var advanced: Bool = false
    @State var professional: Bool = false
    @State var master: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What is your cooking level? 🍳")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Please select your cooking level for a better recommendations.")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    VStack(spacing: 16) {
                        Button {
                            novice = true
                            intermediate = false
                            advanced = false
                            professional = false
                            master = false
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Novice")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                    Spacer()
                                }
                                Text("Basic understanding of kitchen tools and basic cooking techniques such as boiling and frying.")
                                    .foregroundColor(Color("Greyscale700"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .overlay {
                                if novice == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Primary"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                            }
                        }
                        
                        Button {
                            novice = false
                            intermediate = true
                            advanced = false
                            professional = false
                            master = false
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Intermediate")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                    Spacer()
                                }
                                Text("Ability to follow recipes, prepare simple dishes, and basic knife skills.")
                                    .foregroundColor(Color("Greyscale700"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .overlay {
                                if intermediate == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Primary"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                            }
                        }
                        
                        Button {
                            novice = false
                            intermediate = false
                            advanced = true
                            professional = false
                            master = false
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Advanced")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                    Spacer()
                                }
                                Text("Understanding of cooking principles, create recipes, & proficiency in various cooking techniques such as baking, grilling, & roasting.")
                                    .foregroundColor(Color("Greyscale700"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .overlay {
                                if advanced == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Primary"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                            }
                        }

                        
                        Button {
                            novice = false
                            intermediate = false
                            advanced = false
                            professional = true
                            master = false
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Professional")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                    Spacer()
                                }
                                Text("Extensive knowledge of cooking techniques and ingredients, ability to work in a fast-paced environment, and experience in a professional kitchen setting.")
                                    .foregroundColor(Color("Greyscale700"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .overlay {
                                if professional == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Primary"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                            }
                        }

                        
                        Button {
                            novice = false
                            intermediate = false
                            advanced = false
                            professional = false
                            master = true
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Master")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                    Spacer()
                                }
                                Text("Exceptional culinary skills, ability to create innovative dishes, and mastery of advanced cooking techniques.")
                                    .foregroundColor(Color("Greyscale700"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .overlay {
                                if master == true {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Primary"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color("Greyscale200"))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .padding(.top, 40)
            }
            
            if novice == false && intermediate == false && advanced == false && professional == false && master == false {
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
            } else {
                NavigationLink {
                    CuisinePreferenceView()
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
            }
        }
        .padding(.horizontal, 24)
        .background(Color("White"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-33")
            }
        }
    }
}

struct CookingLevelView_Previews: PreviewProvider {
    static var previews: some View {
        CookingLevelView()
    }
}
