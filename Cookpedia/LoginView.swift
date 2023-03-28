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
    @State private var isCheckboxChecked: Bool = true
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
                            TextField("", text: $email)
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
                                if isPasswordHidden {
                                    SecureField("", text: $password)
                                        .font(Font.custom("Urbanist-Bold", size: 20))
                                        .foregroundColor(Color("Greyscale900"))
                                        .textContentType(.password)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                } else {
                                    TextField("", text: $password)
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
                            Button {
                                isCheckboxChecked.toggle()
                            } label: {
                                HStack (spacing: 16) {
                                    Image(isCheckboxChecked == true ? "checkbox-checked" : "checkbox-unchecked")
                                    Text("Remember me")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-SemiBold", size: 18))
                                }
                                
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
                    
                    VStack(spacing: 46) {
                        HStack {
                            VStack {
                                Divider()
                                    .frame(width: 110)
                            }
                            Spacer()
                            Text("or continue with")
                                .foregroundColor(Color("Greyscale700"))
                                .font(.custom("Urbanist-Medium", size: 18))
                                .multilineTextAlignment(.center)
                            Spacer()
                            VStack {
                                Divider()
                                    .frame(width: 110)
                            }
                            
                        }
                        HStack(spacing: 16) {
                            Button {
                                //
                            } label: {
                                Image("google-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(maxWidth: .infinity)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                            .frame(height: 60)
                                            
                                    }
                            }
                            Button {
                                //
                            } label: {
                                Image("apple-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(maxWidth: .infinity)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                            .frame(height: 60)
                                            
                                    }
                            }
                            Button {
                                //
                            } label: {
                                Image("facebook-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .frame(maxWidth: .infinity)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color("Greyscale200"), lineWidth: 1)
                                            .frame(height: 60)
                                    }
                            }
                        }
                    }
                }
                .padding(.top, 40)
            }
            
            Button {
                print(email + password)
            } label: {
                Text("Sign In")
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
        .padding(.horizontal, 24)
        .background(Color("White"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
