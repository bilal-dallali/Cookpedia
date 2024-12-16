//
//  CreateNewPasswordView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/11/2024.
//

import SwiftUI
import SwiftData

struct CreateNewPasswordView: View {
    
    @Binding var email: String
    @Binding var code: [String]
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State var rememberMe: Bool = false
    
    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    
    @State private var passwordNotIdentical: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var loadingScreen: Bool = false
    @State private var loadedScreen: Bool = false
    @State private var isRotating: Bool = false
    
    @State var errorMessage: String?
    
    var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
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
                                VStack(spacing: 8) {
                                    HStack {
                                        if isPasswordHidden {
                                            SecureField(text: $password) {
                                                Text("Password")
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
                                        } else {
                                            TextField(text: $password) {
                                                Text("Password")
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
                                        }
                                        Button {
                                            isPasswordHidden.toggle()
                                        } label: {
                                            Image(isPasswordHidden ? "hidden-eye" : "eye")
                                        }

                                    }
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                                if password != "" && password.count <= 8 {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("Your password is weak, try a better one!")
                                            .foregroundStyle(Color("Error"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .clipShape(.rect(cornerRadius: 10))
                                } else if password.count >= 8 && password.rangeOfCharacter(from: .uppercaseLetters) != nil && password.rangeOfCharacter(from: .lowercaseLetters) != nil && password.rangeOfCharacter(from: .decimalDigits) != nil {
                                    HStack(spacing: 6) {
                                        Image("green-alert")
                                            .padding(.leading, 12)
                                        Text("Your password is strong enough.")
                                            .foregroundStyle(Color("MyGreen"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentGreen"))
                                    .clipShape(.rect(cornerRadius: 10))
                                } else if password.count >= 8 {
                                    HStack(spacing: 6) {
                                        Image("yellow-alert")
                                            .padding(.leading, 12)
                                        Text("Your password is correct, but you can do better")
                                            .foregroundStyle(Color("MyOrange"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentYellow"))
                                    .clipShape(.rect(cornerRadius: 10))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Confirm Password")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(spacing: 8) {
                                    HStack {
                                        if isConfirmPasswordHidden {
                                            SecureField(text: $confirmPassword) {
                                                Text("Confirm Password")
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
                                        } else {
                                            TextField(text: $confirmPassword) {
                                                Text("Confirm Password")
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
                                        }
                                        Button {
                                            isConfirmPasswordHidden.toggle()
                                        } label: {
                                            Image(isConfirmPasswordHidden ? "hidden-eye" : "eye")
                                        }

                                    }
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                                if passwordNotIdentical {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("Confirm password and password must be identical!")
                                            .foregroundStyle(Color("Error"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .clipShape(.rect(cornerRadius: 10))
                                }
                            }
                            
                            Button {
                                rememberMe.toggle()
                            } label: {
                                HStack(spacing: 16) {
                                    Image(rememberMe ? "checkbox-checked" : "checkbox-unchecked")
                                    Text("Remember me")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Semibold", size: 18))
                                }
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
                    if password != "" && confirmPassword != "" {
                        if password == confirmPassword {
                            Button {
                                apiPostManager.resetPassword(email: email, newPassword: password, resetCode: code.joined(), rememberMe: rememberMe) { result in
                                    switch result {
                                    case .success(let (token, id)):
                                        // Get the userId
                                        var userId: String = String(id)
                                        // Store session in SwiftData
                                        let userSession = UserSession(userId: userId, email: email, authToken: token, isRemembered: rememberMe)
                                        context.insert(userSession)
                                        do {
                                            try context.save()
                                        } catch {
                                            print("Failed to save user session: \(error.localizedDescription)")
                                        }
                                        withAnimation(.smooth) {
                                            loadingScreen = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                loadingScreen = false
                                                loadedScreen = true
                                            }
                                        }
                                    case .failure(let error):
                                        errorMessage = error.localizedDescription
                                    }
                                }
                            } label: {
                                Text("Continue")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 58)
                                    .background(Color("Primary900"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                            }
                            .navigationDestination(isPresented: $redirectHomePage) {
                                TabView()
                            }
                        } else {
                            Button {
                                passwordNotIdentical = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    passwordNotIdentical = false
                                }
                            } label: {
                                Text("Continue")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 58)
                                    .background(Color("Primary900"))
                                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                            }
                            
                        }
                    } else {
                        Text("Continue")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("DisabledButton"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    }
                    
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .frame(height: 84)
                .frame(maxWidth: .infinity)
                .background(Color("Dark1"))
            }
            .background(Color(loadingScreen || loadedScreen ? "BackgroundOpacity" : "Dark1"))
            .blur(radius: loadingScreen || loadedScreen ? 4 : 0)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
            }
            if loadingScreen {
                VStack(spacing: 32) {
                    Image("modal-icon")
                    VStack(spacing: 16) {
                        Text("Reseting password")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Bold", size: 24))
                            .multilineTextAlignment(.center)
                        Text("Your password is being\nchanged.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 16))
                            .multilineTextAlignment(.center)
                    }
                    Image("modal-loader")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(isRotating ? 360 : 0))
                        .onAppear {
                            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                isRotating = true
                            }
                        }
                }
                
                .padding(.top, 40)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                .frame(width: 340)
                .background(Color("Dark2"))
                .clipShape(RoundedRectangle(cornerRadius: 40))
            } else if loadedScreen {
                VStack(spacing: 32) {
                    Image("modal-icon-successful")
                    VStack(spacing: 16) {
                        Text("Reset Password\nSuccessful!")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Bold", size: 24))
                            .multilineTextAlignment(.center)
                        Text("Your password has been successfully\nchanged.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 16))
                            .multilineTextAlignment(.center)
                    }
                    Button {
                        self.redirectHomePage = true
                    } label: {
                        Text("Go to Home")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(width: 276, height: 58)
                            .background(Color("Primary900"))
                            .clipShape(.rect(cornerRadius: .infinity))
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                .frame(width: 340)
                .background(Color("Dark2"))
                .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        }
    }
}

#Preview {
    CreateNewPasswordView(email: .constant(""), code: .constant(["", "", "", ""]))
}
