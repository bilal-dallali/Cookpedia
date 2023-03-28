//
//  CompleteProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/03/2023.
//

import SwiftUI

struct CompleteProfileView: View {
    
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var gender = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Complete Your Profile 📋")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Don't worry, only you can see your personal data. No one else will be able to see it.")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    
                    VStack(spacing: 24) {
                        HStack {
                            Spacer()
                            Button {
                                //
                            } label: {
                                Image("avatar")
                            }
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Full Name")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("Full Name", text: $fullName)
                                .autocapitalization(.none)
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                                //.focused($emailFieldIsFocused)
                                .frame(height: 41)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.top), alignment: .bottom
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Phone Number")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("Phone Number", text: $phoneNumber)
                                .autocapitalization(.none)
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                                //.focused($emailFieldIsFocused)
                                .frame(height: 41)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.top), alignment: .bottom
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Gender")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("Gender", text: $gender)
                                .autocapitalization(.none)
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                                //.focused($emailFieldIsFocused)
                                .frame(height: 41)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.top), alignment: .bottom
                                )
                        }
                    }
                }
                .padding(.top, 40)
            }

            Button {
                //
                print("full name:", fullName)
                print("phone number:", phoneNumber)
                print("gender:", gender)
            } label: {
                Text("Continue")
                    .foregroundColor(Color("White"))
                    .font(.custom("Urbanist-Bold", size: 16))
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color("DisabledButton"))
                    .cornerRadius(.infinity)
                    //.shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 4, x: 4, y: 8)
                    .padding(.top, 24)
                    .padding(.bottom)
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
                Image("progress-bar-80")
            }
        }
    }
}

struct CompleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteProfileView()
    }
}
