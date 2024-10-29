//
//  CreateAccountView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/10/2024.
//

import SwiftUI

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
    
    @State var username = ""
    @State var email = ""
    @State var confirmEmail = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    @State private var isCheckboxChecked: Bool = true
    @State private var passwordNotIdentical: Bool = false
    @State private var emailNotIdentical: Bool = false
    @State private var emailInvalid: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var loadingScreen = false
    @State private var alertUsersExists = false
    
    @State var errorMessage: String?
    var apiManager = APIRequest()
    
    var body: some View {
        VStack {
            ZStack {
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
                                .textInputAutocapitalization(.none)
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
                                .textInputAutocapitalization(.none)
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
                                .textInputAutocapitalization(.none)
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
                                        .textInputAutocapitalization(.none)
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
                                        .textInputAutocapitalization(.none)
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
                            HStack {
                                if isPasswordHidden {
                                    SecureField("", text: $confirmPassword)
                                        .placeholder(when: confirmPassword.isEmpty) {
                                            Text("Confirm Password")
                                                .foregroundStyle(Color("Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                        }
                                        .textInputAutocapitalization(.none)
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
                                        .textInputAutocapitalization(.none)
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
                        
                    }
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 0) {
                    Spacer()
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color("Dark4"))
                        }
                    VStack {
                        Button {
                            //
                        } label: {
                            Text("Continue")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(Color("Primary900"))
                                .clipShape(.rect(cornerRadius: .infinity))
                                .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                .padding(.top, 24)
                                .padding(.horizontal, 24)
                        }

                        
                        Spacer()
                    }
                    .frame(height: 118)
                    .frame(maxWidth: .infinity)
                    .background(Color("Dark1"))
                    
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-100")
            }
        }
    }
}

#Preview {
    CreateAccountView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false), vegetarian: .constant(false), vegan: .constant(false), glutenFree: .constant(false), nutFree: .constant(false), dairyFree: .constant(false), lowCarb: .constant(false), peanutFree: .constant(false), keto: .constant(false), soyFree: .constant(false), rawFood: .constant(false), lowFat: .constant(false), halal: .constant(false), fullName: .constant("JK Rowling"), phoneNumber: .constant("0600000000"), gender: .constant("Male"), date: .constant("12/05/1997"), city: .constant("London"), profilePictureUrl: .constant("profile-picture"))
}
