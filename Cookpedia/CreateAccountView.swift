//
//  CreateAccountView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 02/04/2023.
//

import SwiftUI

struct CreateAccountView: View {
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordHidden: Bool = false
    @State private var isConfirmPasswordHidden: Bool = false
    @State private var isCheckboxChecked: Bool = true
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Create an Account 🔐")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Enter your username, email & password. If you forget it, then you have to do forgot password.")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Username")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("", text: $username)
                                .placeholder(when: username.isEmpty) {
                                    Text("Username")
                                        .foregroundColor(Color("Greyscale500"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .autocapitalization(.none)
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                                .frame(height: 41)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.top), alignment: .bottom
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Email")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("", text: $email)
                                .placeholder(when: email.isEmpty) {
                                    Text("Email")
                                        .foregroundColor(Color("Greyscale500"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .autocapitalization(.none)
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                                .frame(height: 41)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.top), alignment: .bottom
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Password")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            HStack {
                                if isPasswordHidden {
                                    SecureField("", text: $password)
                                        .placeholder(when: password.isEmpty) {
                                            Text("Password")
                                                .foregroundColor(Color("Greyscale500"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .foregroundColor(Color("Greyscale900"))
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                } else {
                                    TextField("", text: $password)
                                        .placeholder(when: password.isEmpty) {
                                            Text("Password")
                                                .foregroundColor(Color("Greyscale500"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .foregroundColor(Color("Greyscale900"))
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                Spacer()
                                Button {
                                    isPasswordHidden.toggle()
                                } label: {
                                    Image(isPasswordHidden == true ? "hidden-eye" : "eye")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                            }
                            .frame(height: 41)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("Primary"))
                                    .padding(.top), alignment: .bottom
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Confirm Password")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            HStack {
                                if isConfirmPasswordHidden {
                                    SecureField("", text: $confirmPassword)
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirm Password")
                                                .foregroundColor(Color("Greyscale500"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .foregroundColor(Color("Greyscale900"))
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                } else {
                                    TextField("", text: $confirmPassword)
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirm Password")
                                                .foregroundColor(Color("Greyscale500"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .font(.custom("Urbanist-Bold", size: 20))
                                        .foregroundColor(Color("Greyscale900"))
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                Spacer()
                                Button {
                                    isConfirmPasswordHidden.toggle()
                                } label: {
                                    Image(isConfirmPasswordHidden == true ? "hidden-eye" : "eye")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                            }
                            .frame(height: 41)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("Primary"))
                                    .padding(.top), alignment: .bottom
                            )
                        }
                        
                        Button {
                            isCheckboxChecked.toggle()
                        } label: {
                            HStack(spacing: 16) {
                                Image(isCheckboxChecked ? "checkbox-checked" : "checkbox-unchecked")
                                Text("Remember me")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Semibold", size: 18))
                            }
                        }
                    }
                }
                .padding(.top, 40)
            }
            
            Button {
                //
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
                Image("progress-bar-100")
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
