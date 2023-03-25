//
//  LoginView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/03/2023.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @FocusState private var emailFieldIsFocused: Bool
    @State private var isPasswordHidden: Bool = true
    @State private var isCheckboxChecked: Bool = false
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hello there 👋")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Please enter your username/email and password to sign in.")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Username / Email")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("Email or Username", text: $email)
                                .autocapitalization(.none)
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                                .focused($emailFieldIsFocused)
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
                                if isPasswordHidden == true {
                                    SecureField("Password", text: $password)
                                        .font(Font.custom("Urbanist-Bold", size: 20))
                                        .foregroundColor(Color("Greyscale900"))
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                } else {
                                    TextField("Password", text: $password)
                                        .font(Font.custom("Urbanist-Bold", size: 20))
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
                        
                        HStack {
                            HStack(spacing: 16) {
                                Button {
                                    isCheckboxChecked.toggle()
                                } label: {
                                    Image(isCheckboxChecked == false ? "checkbox-checked" : "checkbox-unchecked")
                                }
                                Text("Remember me")
                                    .font(.custom("Urbanist-SemiBold", size: 18))
                                    
                            }
                            Spacer()
                        }
                        Divider()
                        
                        NavigationLink {
                            ForgotPasswordView()
                        } label: {
                            Text("Forgot Password")
                                .foregroundColor(Color("Primary"))
                                .font(.custom("Urbanist-Bold", size: 18))
                        }
                    }
                    
                    VStack(spacing: 24) {
                        
                    }
                }
                .padding(.top, 40)
                
                
            }
            
            Button {
                //
            } label: {
                HStack {
                    Spacer()
                    Text("Sign In")
                        .foregroundColor(Color("White"))
                        .frame(height: 58)
                        .font(.custom("Urbanist-Bold", size: 16))
                    Spacer()
                }
                .background(Color("Primary"))
                .cornerRadius(.infinity)
                .padding(.top, 24)
                .padding(.bottom)
            }
        }
        .padding(.horizontal, 24)
        .background(Color("White"))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
