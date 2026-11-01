//
//  CookingLevelView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 26/10/2024.
//

import SwiftUI

struct CookingLevelView: View {
    
    @Binding var draft: SignupDraft
    @State private var progressViewWidth: CGFloat = 54
    
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
                            draft.cookingLevel = .novice
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
                                if draft.cookingLevel == .novice {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            draft.cookingLevel = .intermediate
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
                                if draft.cookingLevel == .intermediate {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            draft.cookingLevel = .advanced
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
                                if draft.cookingLevel == .advanced {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            draft.cookingLevel = .professional
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
                                if draft.cookingLevel == .professional {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color("Dark4"), lineWidth: 2)
                                }
                            }
                        }
                        
                        Button {
                            draft.cookingLevel = .master
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
                                if draft.cookingLevel == .master {
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
                if draft.cookingLevel == nil {
                    Text("Continue")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .clipShape(.rect(cornerRadius: .infinity))
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 36)
                } else {
                    NavigationLink {
                        CompleteProfileView(draft: $draft)
                    } label: {
                        Text("Continue")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Primary900"))
                            .clipShape(.rect(cornerRadius: .infinity))
                            .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 36)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeIn(duration: 1)) {
                    progressViewWidth = 108
                }
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
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundStyle(Color("Dark4"))
                    .frame(width: 216, height: 12)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(Color("Primary900"))
                            .frame(width: progressViewWidth, height: 12)
                    }
            }
        }
    }
}

#Preview {
    CookingLevelView(draft: .constant(SignupDraft(country: "France")))
}
