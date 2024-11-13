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
    @Environment(\.modelContext) private var context: ModelContext
    @EnvironmentObject private var apiPostManager: APIPostRequest
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
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
                                print("\(email)\n\(password)")
                                isLoading = true
                                apiPostManager.loginUser(email: email, password: password, rememberMe: rememberMe) { result in
                                    switch result {
                                    case .success(let authToken):
                                        // Store session in SwiftData
                                        let userSession = UserSession(userId: email, authToken: authToken, isRemembered: rememberMe)
                                        context.insert(userSession)
                                        do {
                                            try context.save()
                                            print("USER SESSION SUCCESSFULLY SAVED TO SWIFTDATA")
                                            print("usersession token: \(userSession.authToken)")
                                            print("usersession remember: \(userSession.isRemembered)")
                                        } catch {
                                            print("Failed to save user session: \(error.localizedDescription)")
                                        }
                                        print("USER SUCCESSFULLY CONNECTED!!!")
                                        loadingScreen = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.redirectHomePage = true
                                            loadingScreen = false
                                        }
                                    case .failure(let error):
                                        print("Registration failed: \(error.localizedDescription)")
                                        switch error {
                                        case .invalidUrl:
                                            // afficher un message d'erreur pour une URL invalide
                                            errorMessage = "URL invalid"
                                            alertUsersExists = true
                                            print("URL INVALIDE !!!!!")
                                            break
                                        case .invalidData:
                                            // afficher un message d'erreur pour des données invalides
                                            errorMessage = "Your datas are invalid, please try again later!"
                                            alertUsersExists = true
                                            print("DATA INVALID !!!")
                                            break
                                        case .invalidCredentials:
                                            // afficher un message d'erreur pour un mot de passe invalide
                                            errorMessage = "Incorrect password"
                                            alertUsersExists = true
                                            print("INVALID PASSWORD!!!")
                                            break
                                        case .userNotFound:
                                            // Afficher un message d'erreur pour un utilisateur non trouvé
                                            errorMessage = "User not found"
                                            alertUsersExists = true
                                            print("USER NOT FOUND!!!")
                                            break
                                            
                                        case .emailAlreadyExists:
                                            // afficher un message d'erreur pour un e-mail déjà existant
                                            errorMessage = "This email address is already registered"
                                            alertUsersExists = true
                                            print("EMAIL EXISTS !!!")
                                            break
                                        case .usernameAlreadyExists:
                                            // afficher un message d'erreur pour un nom d'utilisateur déjà existant
                                            errorMessage = "This username is already registered"
                                            alertUsersExists = true
                                            print("USERNAME EXISTS !!!!")
                                            break
                                        case .phoneNumberAlreadyExists:
                                            // afficher un message d'erreur pour un numéro de téléphone déjà existant
                                            errorMessage = "This phone number is already registered"
                                            alertUsersExists = true
                                            print("PHONE NUMBER EXISTS !!!!")
                                            break
                                        case .serverError:
                                            // afficher un message d'erreur pour une erreur du serveur
                                            errorMessage = "Server error"
                                            alertUsersExists = true
                                            print("SERVER ERROR!!!!")
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
            if loadingScreen {
                SignUpSuccessfulView(title: "Sign In Successful!", message: "Your informations are valid. Please wait a moment, we are preparing for you...")
            }
        }
    }
}

#Preview {
    LoginView()
}
