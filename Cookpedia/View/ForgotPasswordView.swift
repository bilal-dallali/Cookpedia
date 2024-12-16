//
//  ForgotPasswordView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 03/11/2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State var email: String = ""
    
    @State private var emailInvalid: Bool = false
    @State private var emailDoesntExist: Bool = false
    @State private var showOTPScreen: Bool = false
    @State private var errorMessage: String?
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
                        VStack(spacing: 8) {
                            TextField(text: $email) {
                                Text("Email")
                                    .foregroundStyle(Color("Dark4"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                            }
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .frame(height: 32)
                            .onSubmit {
                                
                            }
                            Rectangle()
                                .foregroundStyle(Color("Primary900"))
                                .frame(height: 1)
                        }

                        if emailInvalid {
                            HStack(spacing: 6) {
                                Image("red-alert")
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
                                Image("red-alert")
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
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 24)
            
            Divider()
                .overlay {
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color("Dark4"))
                }
            VStack {
                if email != "" {
                    if isValidEmail(email) {
                        Button {
                            apiPostManager.sendResetCode(email: email) { result in
                                switch result {
                                case .success:
                                    showOTPScreen = true
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
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
                }
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
        }
        .navigationDestination(isPresented: $showOTPScreen) {
            ForgotPasswordCheckEmailView(email: $email)
        }
    }
}

#Preview {
    ForgotPasswordView()
}
