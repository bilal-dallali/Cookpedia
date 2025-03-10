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
    @FocusState private var isTextFocused: Bool
    
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
    
    @State private var errorMessage: String?
    
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
                                            .focused($isTextFocused)
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
                                            .focused($isTextFocused)
                                            .onSubmit {
                                                
                                            }
                                        }
                                        Button {
                                            isPasswordHidden.toggle()
                                        } label: {
                                            Image(isPasswordHidden ? "Hide - Regular - Bold" : "Show - Regular - Bold")
                                                .resizable()
                                                .frame(width: 28, height: 28)
                                                .foregroundStyle(Color("Primary900"))
                                        }

                                    }
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                                if password != "" && password.count <= 8 {
                                    HStack(spacing: 6) {
                                        Image("Info Circle - Regular - Bold")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color("Error"))
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
                                        Image("Info Circle - Regular - Bold")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color("MyGreen"))
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
                                        Image("Info Circle - Regular - Bold")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color("MyOrange"))
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
                                            .focused($isTextFocused)
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
                                            .focused($isTextFocused)
                                            .onSubmit {
                                                
                                            }
                                        }
                                        Button {
                                            isConfirmPasswordHidden.toggle()
                                        } label: {
                                            Image(isConfirmPasswordHidden ? "Hide - Regular - Bold" : "Show - Regular - Bold")
                                                .resizable()
                                                .frame(width: 28, height: 28)
                                                .foregroundStyle(Color("Primary900"))
                                        }

                                    }
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                                if passwordNotIdentical {
                                    HStack(spacing: 6) {
                                        Image("Info Circle - Regular - Bold")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(Color("Error"))
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
                                    Image(rememberMe ? "checked-checkbox" : "unchecked-checkbox")
                                    Text("Remember me")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-Semibold", size: 18))
                                }
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
                    if password != "" && confirmPassword != "" {
                        if password == confirmPassword {
                            Button {
                                Task {
                                    do {
                                        let result = try await apiPostManager.resetPassword(email: email, newPassword: password, resetCode: code.joined(), rememberMe: rememberMe)
                                        let userSession = UserSession(userId: result.id, email: email, authToken: result.token, isRemembered: rememberMe)
                                        context.insert(userSession)
                                        do {
                                            try context.save()
                                        } catch {
                                            print("Failed to save user session: \(error.localizedDescription)")
                                        }
                                        withAnimation(.smooth) {
                                            loadingScreen = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                loadingScreen = false
                                                loadedScreen = true
                                            }
                                        }
                                    } catch let error as APIPostError {
                                        print("Error: \(error.localizedDescription)")
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
                                    .padding(.horizontal, 24)
                                    .padding(.top, 24)
                                    .padding(.bottom, 36)
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
                                    .padding(.horizontal, 24)
                                    .padding(.top, 24)
                                    .padding(.bottom, 36)
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
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 36)
                    }
                }
            }
            .background(Color(loadingScreen || loadedScreen ? "BackgroundOpacity" : "Dark1"))
            .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
            .blur(radius: loadingScreen || loadedScreen ? 4 : 0)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
            }
            .onTapGesture {
                isTextFocused = false
            }
            if loadingScreen {
                VStack(spacing: 32) {
                    Image("modal")
                        .resizable()
                        .frame(width: 186, height: 180)
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
                    Image("loader")
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
                    Image("modal-successful")
                        .resizable()
                        .frame(width: 186, height: 180)
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
