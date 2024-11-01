//
//  LoginView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 01/11/2024.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @FocusState private var emailFieldIsFocused: Bool
    
    @State private var isPasswordHidden: Bool = true
    @State private var isCheckboxChecked: Bool = true
    @State private var isPresented: Bool = false
    
    @State private var emailInvalid: Bool = false
    @State private var redirectHomePage: Bool = false
    
    @State private var loginError: String? = nil
    @State private var isLoading: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var loadingScreen = false
    
    @State private var alertUsersExists = false
    @State var errorMessage: String?
    
    var apiManager = APIRequest()
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hello there 👋")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Please enter your username/email and password to sign in.")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Regular", size: 18))
                        }
                        
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Email")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $email)
                                    .placeholder(when: email.isEmpty) {
                                        Text("Email")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.default)
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(height: 41)
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                            .padding(.top, 33)
                                    }
                                if emailInvalid {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("You must enter a valid email")
                                            .foregroundStyle(Color("Error"))
                                            .font(.custom("Urbanist-SemiBold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .clipShape(.rect(cornerRadius: 10))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Password")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                HStack {
                                    if isPasswordHidden {
                                        SecureField("", text: $password)
                                            .placeholder(when: password.isEmpty) {
                                                Text("Password")
                                                    .foregroundStyle(Color("Dark4"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                            }
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.default)
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    } else {
                                        TextField("", text: $password)
                                            .placeholder(when: password.isEmpty) {
                                                Text("Password")
                                                    .foregroundStyle(Color("Dark4"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                            }
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.default)
                                            .foregroundStyle(Color("MyWhite"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    Spacer()
                                    Button {
                                        isPasswordHidden.toggle()
                                    } label: {
                                        Image(isPasswordHidden ? "hidden-eye" : "eye")
                                            .resizable()
                                            .frame(width: 28, height: 28)
                                    }
                                    
                                }
                                .frame(height: 41)
                                .overlay {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Primary900"))
                                        .padding(.top, 33)
                                }
                            }
                            
                            Button {
                                isCheckboxChecked.toggle()
                            } label: {
                                HStack(spacing: 16) {
                                    Image(isCheckboxChecked ? "checkbox-checked" : "checkbox-unchecked")
                                    Text("Remember me")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Semibold", size: 18))
                                    Spacer()
                                }
                            }
                            
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .foregroundStyle(Color("Dark4"))
                                        .frame(height: 1)
                                }
                            Button {
                                //
                            } label: {
                                Text("Forgot Password")
                                    .foregroundStyle(Color("Primary900"))
                                    .font(.custom("Urbanist-Bold", size: 18))
                            }
                        }
                        
                        VStack(spacing: 24) {
                            HStack(spacing: 16) {
                                Rectangle()
                                    .foregroundStyle(Color("Dark4"))
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                Text("or continue with")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Medium", size: 18))
                                    .frame(width: 130)
                                Rectangle()
                                    .foregroundStyle(Color("Dark4"))
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            HStack(spacing: 16) {
                                Button {
                                    //
                                } label: {
                                    VStack {
                                        Image("google-logo")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(height: 60)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color("Dark4"), lineWidth: 1)
                                    }
                                }
                                
                                Button {
                                    //
                                } label: {
                                    VStack {
                                        Image("apple-logo")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(height: 60)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color("Dark4"), lineWidth: 1)
                                    }
                                }
                                
                                Button {
                                    //
                                } label: {
                                    VStack {
                                        Image("facebook-logo")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(height: 60)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(Color("Dark4"), lineWidth: 1)
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 120)

                VStack(spacing: 0) {
                    Spacer()
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color("Dark4"))
                        }
                    VStack {
                        Text("Continue")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Primary900"))
                            .clipShape(.rect(cornerRadius: .infinity))
                            .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                        Spacer()
                    }
                    .frame(height: 118)
                    .frame(maxWidth: .infinity)
                    .background(Color("Dark1"))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
    }
}

#Preview {
    LoginView()
}
