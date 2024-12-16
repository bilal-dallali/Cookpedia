//
//  LoginView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 01/11/2024.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @FocusState private var emailFieldIsFocused: Bool
    @State private var isPasswordHidden: Bool = true
    @State private var isPresented: Bool = false
    @State private var emailInvalid: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var loginError: String? = nil
    @State private var isLoading: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var loadingScreen = false
    @State private var alertUsersExists = false
    @State var errorMessage: String?
    
    @State private var email = ""
    @State private var password = ""
    @State var rememberMe: Bool = false
    
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
                            }
                            
                            Button {
                                rememberMe.toggle()
                            } label: {
                                HStack(spacing: 16) {
                                    Image(rememberMe ? "checkbox-checked" : "checkbox-unchecked")
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
                    if email != "" && password != "" {
                        if isValidEmail(email) {
                            Button {
                                isLoading = true
                                apiPostManager.loginUser(email: email, password: password, rememberMe: rememberMe) { result in
                                    switch result {
                                    case .success(let (token, id)):
                                        // Get the userId from the token
                                        var userId: String = String(id)
                                        // Store session in SwiftData
                                        let userSession = UserSession(userId: userId, email: email, authToken: token, isRemembered: rememberMe)
                                        context.insert(userSession)
                                        //UserSession.shared = userSession
                                        do {
                                            try context.save()
                                        } catch {
                                            print("Failed to save user session: \(error.localizedDescription)")
                                        }
                                        loadingScreen = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.redirectHomePage = true
                                            loadingScreen = false
                                        }
                                    case .failure(let error):
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
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .frame(height: 84)
                .frame(maxWidth: .infinity)
                .background(Color("Dark1"))
            }
            .background(Color(loadingScreen ? "BackgroundOpacity" : "Dark1"))
            .blur(radius: loadingScreen ? 4 : 0)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
            }
            .onTapGesture {
                dismissKeyboard()
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
