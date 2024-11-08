//
//  CreateNewPasswordView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/11/2024.
//

import SwiftUI

struct CreateNewPasswordView: View {
    
    @Binding var email: String
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    
    @State private var isCheckboxChecked: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Create New Password 🔐")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Enter your new password. If you forget it, then you have to do forgot password.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
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
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Confirm Password")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            HStack {
                                if isPasswordHidden {
                                    SecureField("", text: $confirmPassword)
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirm Password")
                                                .foregroundStyle(Color("Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                } else {
                                    TextField("", text: $confirmPassword)
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirm Password")
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
                                    isConfirmPasswordHidden.toggle()
                                } label: {
                                    Image(isConfirmPasswordHidden ? "hidden-eye" : "eye")
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
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Divider()
                .overlay {
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color("Dark4"))
                }
            VStack {
                Text("Confirm")
                    .foregroundStyle(Color("MyWhite"))
                    .font(.custom("Urbanist-Bold", size: 16))
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color("Primary900"))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                Spacer()
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
    }
}

#Preview {
    CreateNewPasswordView(email: .constant(""))
}
