//
//  CreateAccountView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/10/2024.
//

import SwiftUI
import SwiftData

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

struct CreateAccountView: View {
    
    @Binding var country: String
    @Binding var level: String
    @Binding var salad: Bool
    @Binding var egg: Bool
    @Binding var soup: Bool
    @Binding var meat: Bool
    @Binding var chicken: Bool
    @Binding var seafood: Bool
    @Binding var burger: Bool
    @Binding var pizza: Bool
    @Binding var sushi: Bool
    @Binding var rice: Bool
    @Binding var bread: Bool
    @Binding var fruit: Bool
    @Binding var vegetarian: Bool
    @Binding var vegan: Bool
    @Binding var glutenFree: Bool
    @Binding var nutFree: Bool
    @Binding var dairyFree: Bool
    @Binding var lowCarb: Bool
    @Binding var peanutFree: Bool
    @Binding var keto: Bool
    @Binding var soyFree: Bool
    @Binding var rawFood: Bool
    @Binding var lowFat: Bool
    @Binding var halal: Bool
    @Binding var fullName: String
    @Binding var phoneNumber: String
    @Binding var gender: String
    @Binding var date: String
    @Binding var city: String
    @Binding var profilePictureUrl: String
    @Binding var selectedImage: UIImage?
    
    @State var username = ""
    @State var email = ""
    @State var confirmEmail = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    @State var rememberMe: Bool = false
    @State private var passwordNotIdentical: Bool = false
    @State private var emailNotIdentical: Bool = false
    @State private var emailInvalid: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var loadingScreen = false
    @State private var alertUsersExists = false
    @State var errorMessage: String?
    
    var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Create an Account 🔐")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Enter your username, email & password. If you forget it, then you have to do forgot password.")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Regular", size: 18))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Username")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("", text: $username)
                                .placeholder(when: username.isEmpty) {
                                    Text("Username")
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
                        }
                        
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
                                .keyboardType(.emailAddress)
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
                                        .font(.custom("Urbanist-Bold", size: 12))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(Color("TransparentRed"))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Confirm Email")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("", text: $confirmEmail)
                                .placeholder(when: confirmEmail.isEmpty) {
                                    Text("Confirm Email")
                                        .foregroundStyle(Color("Dark4"))
                                        .font(.custom("Urbanist-Bold", size: 20))
                                }
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                                .frame(height: 41)
                                .overlay {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Primary900"))
                                        .padding(.top, 33)
                                }
                            
                            if emailNotIdentical {
                                HStack(spacing: 6) {
                                    Image("red-alert")
                                        .padding(.leading, 12)
                                    Text("Confirm email must be identical to email")
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
                                .clipShape(RoundedRectangle(cornerRadius: 10))
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
                            HStack {
                                if isConfirmPasswordHidden {
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
                    if username != "" && email != "" && password != "" && confirmPassword != "" {
                        if password == confirmPassword {
                            if email != "" && email == confirmEmail {
                                if isValidEmail(email) {
                                    Button {
                                        let registration = UserRegistration(username: username, email: email, password: password, country: country, level: level, salad: salad, egg: egg, soup: soup, meat: meat, chicken: chicken, seafood: seafood, burger: burger, pizza: pizza, sushi: sushi, rice: rice, bread: bread, fruit: fruit, vegetarian: vegetarian, vegan: vegan, glutenFree: glutenFree, nutFree: nutFree, dairyFree: dairyFree, lowCarb: lowCarb, peanutFree: peanutFree, keto: keto, soyFree: soyFree, rawFood: rawFood, lowFat: lowFat, halal: halal, fullName: fullName, phoneNumber: phoneNumber, gender: gender, date: date, city: city, profilePictureUrl: profilePictureUrl)
                                        apiPostManager.registerUser(registration: registration, profilePicture: selectedImage, rememberMe: rememberMe) { result in
                                            switch result {
                                            case .success(let authToken):
                                                print("User registered successfully")
                                                let userSession = UserSession(email: email, authToken: authToken, isRemembered: rememberMe)
                                                context.insert(userSession)
                                                do {
                                                    try context.save()
                                                    print("USER SESSION SUCCESSFULLY SAVED TO SWIFTDATA")
                                                    print("usersession token: \(userSession.authToken)")
                                                    print("usersession remember: \(userSession.isRemembered)")
                                                } catch {
                                                    print("Failed to save user session: \(error.localizedDescription)")
                                                }
                                                loadingScreen = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
                                                    print("INVALID CREDENTIALS!!!")
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
                                        Text("Continue")
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
                                        Button("Ok", role: .cancel) {}
                                    }
                                } else {
                                    Button {
                                        emailInvalid = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            emailInvalid = false
                                        }
                                    } label: {
                                        Text("Continue")
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
                                Button {
                                    emailNotIdentical = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        emailNotIdentical = false
                                    }
                                } label: {
                                    Text("Continue")
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
                                    .clipShape(.rect(cornerRadius: .infinity))
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
                ToolbarItem(placement: .principal) {
                    Image("progress-bar-100")
                }
            }
            if loadingScreen {
                SignUpSuccessfulView(title: "Sign Up Successful", message: "Your account has been created. Please wait a moment, we are preparing for you...")
            }
        }
    }
}

#Preview {
    CreateAccountView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false), vegetarian: .constant(false), vegan: .constant(false), glutenFree: .constant(false), nutFree: .constant(false), dairyFree: .constant(false), lowCarb: .constant(false), peanutFree: .constant(false), keto: .constant(false), soyFree: .constant(false), rawFood: .constant(false), lowFat: .constant(false), halal: .constant(false), fullName: .constant("JK Rowling"), phoneNumber: .constant("0600000000"), gender: .constant("Male"), date: .constant("12/05/1997"), city: .constant("London"), profilePictureUrl: .constant("profile-picture"), selectedImage: .constant(nil))
}
