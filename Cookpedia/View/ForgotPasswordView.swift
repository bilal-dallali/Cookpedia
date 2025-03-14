//
//  ForgotPasswordView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 03/11/2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State var email: String = ""
    @FocusState private var isTextFocused: Bool
    @State private var emailInvalid: Bool = false
    @State private var emailDoesntExist: Bool = false
    @State private var showOTPScreen: Bool = false
    var apiPostManager = APIPostRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Forgot Password 🔑")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Enter your email address. We will send an OTP code for verification in the next step.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Email")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                        VStack(spacing: 8) {
                            TextField(text: $email) {
                                Text("Email")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .focused($isTextFocused)
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }

                        if emailInvalid {
                            HStack(spacing: 6) {
                                Image("Info Circle - Regular - Bold")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Error"))
                                    .padding(.leading, 12)
                                Text("You must enter a valid email")
                                    .foregroundStyle(Color("Error"))
                                    .font(.custom("Urbanist-Bold", size: 12))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .background(Color("TransparentRed"))
                            .clipShape(.rect(cornerRadius: 10))
                        } else if emailDoesntExist {
                            HStack(spacing: 6) {
                                Image("Info Circle - Regular - Bold")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Error"))
                                    .padding(.leading, 12)
                                Text("This email address isn't used by one of our client")
                                    .foregroundStyle(Color("Error"))
                                    .font(.custom("Urbanist-Bold", size: 12))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 34)
                            .background(Color("TransparentRed"))
                            .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
            
            VStack(spacing: 0) {
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color("Dark4"))
                    }
                if email != "" {
                    if isValidEmail(email) {
                        Button {
                            Task {
                                do {
                                    try await apiPostManager.sendResetCode(email: email)
                                    showOTPScreen = true
                                } catch let error as APIPostError {
                                    print("Erreur : \(error.localizedDescription)")
                                    if error.localizedDescription.contains("User not found") {
                                        emailDoesntExist = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            emailDoesntExist = false
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Sign In")
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
                    } else {
                        Button {
                            emailInvalid = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                emailInvalid = false
                            }
                        } label: {
                            Text("Sign In")
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
                } else {
                    Text("Sign In")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .clipShape(.rect(cornerRadius: .infinity))
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 36)
                }
            }
        }
        .background(Color("Dark1"))
        .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
        .onTapGesture {
            isTextFocused = false
        }
        .navigationDestination(isPresented: $showOTPScreen) {
            ForgotPasswordCheckEmailView(email: $email)
        }
    }
}

#Preview {
    ForgotPasswordView()
}
