//
//  LoginView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 01/11/2024.
//

import SwiftUI
import SwiftData
import FirebaseCrashlytics

struct LoginView: View {
    
    @FocusState private var isTextFocused: Bool
    @State private var isPasswordHidden: Bool = true
    @State private var isPresented: Bool = false
    @State private var emailInvalid: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var loginError: String? = nil
    @State private var navigateToHome: Bool = false
    @State private var loadingScreen = false
    @State private var alertUsersExists = false
    @State private var errorMessage: String?
    
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe: Bool = false
    
    var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
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
                            }
                            
                            Button {
                                rememberMe.toggle()
                            } label: {
                                HStack(spacing: 16) {
                                    Image(rememberMe ? "checked-checkbox" : "unchecked-checkbox")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color("Primary900"))
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
                            NavigationLink {
                                ForgotPasswordView()
                            } label: {
                                Text("Forgot Password")
                                    .foregroundStyle(Color("Primary900"))
                                    .font(.custom("Urbanist-Bold", size: 18))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
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
                    if email != "" && password != "" {
                        if isValidEmail(email) {
                            Button {
                                Task {
                                    do {
                                        let (token, id) = try await apiPostManager.loginUser(email: email, password: password, rememberMe: rememberMe)
                                        
                                        AnalyticsManager.shared.setUserId(userId: String(id))
                                        AnalyticsManager.shared.logEvent(name: "login_success", params: ["user_id": id])
                                        
                                        // Store session in SwiftData
                                        let userSession = UserSession(userId: id, email: email, authToken: token, isRemembered: rememberMe)
                                        context.insert(userSession)
                                        do {
                                            try context.save()
                                        } catch {
                                            print("Failed to save user session: \(error.localizedDescription)")
                                            CrashManager.shared.setUserId(userId: String(id))
                                        }
                                        loadingScreen = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.redirectHomePage = true
                                            loadingScreen = false
                                        }
                                    } catch let error as APIPostError {
                                        AnalyticsManager.shared.logEvent(name: "login_failed")
                                        DispatchQueue.main.async {
                                            switch error {
                                            case .invalidUrl:
                                                errorMessage = "URL invalid"
                                                alertUsersExists = true
                                                break
                                            case .invalidData:
                                                errorMessage = "Your datas are invalid, please try again later!"
                                                alertUsersExists = true
                                                break
                                            case .invalidCredentials:
                                                errorMessage = "Incorrect password"
                                                alertUsersExists = true
                                                break
                                            case .userNotFound:
                                                errorMessage = "User not found"
                                                alertUsersExists = true
                                                break
                                            case .emailAlreadyExists:
                                                errorMessage = "This email address is already registered"
                                                alertUsersExists = true
                                                break
                                            case .usernameAlreadyExists:
                                                errorMessage = "This username is already registered"
                                                alertUsersExists = true
                                                break
                                            case .phoneNumberAlreadyExists:
                                                errorMessage = "This phone number is already registered"
                                                alertUsersExists = true
                                                break
                                            case .serverError:
                                                errorMessage = "Server error"
                                                alertUsersExists = true
                                                break
                                            case .requestFailed:
                                                errorMessage = "Request failed"
                                                alertUsersExists = true
                                                break
                                            case .invalidResponse:
                                                errorMessage = "Invalid response"
                                                alertUsersExists = true
                                                break
                                            case .decodingError:
                                                errorMessage = "Decoding error"
                                                alertUsersExists = true
                                                break
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
                            .navigationDestination(isPresented: $redirectHomePage) {
                                TabView()
                            }
                            .alert(errorMessage ?? "an error occured", isPresented: $alertUsersExists) {
                                Button("OK", role: .cancel) { }
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
            .background(Color(loadingScreen ? "BackgroundOpacity" : "Dark1"))
            .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
            .blur(radius: loadingScreen ? 4 : 0)
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
                ModalView(title: "Sign In Successful!", message: "Your informations are valid. Please wait a moment, we are preparing for you...")
            }
        }
    }
}

#Preview {
    LoginView()
}
