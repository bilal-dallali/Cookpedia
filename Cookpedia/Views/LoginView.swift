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
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Hello there 👋")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Please enter your email and password to sign in.")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Regular", size: 18))
                        }
                        
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Email")
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
                                
                                
                                if emailInvalid {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("You must enter a valid email")
                                            .foregroundColor(Color("Error"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .cornerRadius(10)
                                }
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
                
                if let loginError = loginError {
                    Text(loginError)
                        .foregroundColor(.red)
                        .font(.custom("Urbanist-Bold", size: 16))
                        .padding(.top, 24)
                }
                
                if email != "" && password != "" {
                    if isValidEmail(email) {
                        Button {
                            print("\(email)\n\(password)")
                            isLoading = true
                            apiManager.loginUser(email: email, password: password) { result in
                                switch result {
                                case .success:
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
                        .navigationDestination(isPresented: $redirectHomePage) {
                            TabView()
                        }
                        .alert(errorMessage ?? "an error occured", isPresented: $alertUsersExists) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                } else {
                    Text("Sign In")
                        .foregroundColor(Color("White"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .cornerRadius(.infinity)
                        .padding(.top, 24)
                        .padding(.bottom)
                }
                
            }
            .padding(.horizontal, 24)
            .background(Color(loadingScreen ? "BackgroundOpacity" : "White"))
            .blur(radius: loadingScreen ? 4 : 0)
            .background(Color("White"))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
            }
            if loadingScreen {
                ModalView(modalTitle: "Sign In Successful!", modalMessage: "Your informations are valid. Please wait a moment, we are preparing for you...")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
