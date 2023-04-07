//
//  CreateAccountView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 02/04/2023.
//

import SwiftUI


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
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Create an Account 🔐")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Enter your username, email & password. If you forget it, then you have to do forgot password.")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Regular", size: 18))
                        }
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Username")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $username)
                                    .placeholder(when: username.isEmpty) {
                                        Text("Username")
                                            .foregroundColor(Color("Greyscale500"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .autocapitalization(.none)
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .foregroundColor(Color("Greyscale900"))
                                    .frame(height: 41)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color("Primary"))
                                            .padding(.top), alignment: .bottom
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Email")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $email)
                                    .placeholder(when: email.isEmpty) {
                                        Text("Email")
                                            .foregroundColor(Color("Greyscale500"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .autocapitalization(.none)
                                    .font(Font.custom("Urbanist-Bold", size: 20))
                                    .foregroundColor(Color("Greyscale900"))
                                    .frame(height: 41)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color("Primary"))
                                            .padding(.top), alignment: .bottom
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Confirm Email")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $confirmEmail)
                                    .placeholder(when: confirmEmail.isEmpty) {
                                        Text("Confirm Email")
                                            .foregroundColor(Color("Greyscale500"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .autocapitalization(.none)
                                    .font(Font.custom("Urbanist-Bold", size: 20))
                                    .foregroundColor(Color("Greyscale900"))
                                    .frame(height: 41)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color("Primary"))
                                            .padding(.top), alignment: .bottom
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Password")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                HStack {
                                    if isPasswordHidden {
                                        SecureField("", text: $password)
                                            .placeholder(when: password.isEmpty) {
                                                Text("Password")
                                                    .foregroundColor(Color("Greyscale500"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                            }
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .foregroundColor(Color("Greyscale900"))
                                            .textContentType(.password)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    } else {
                                        TextField("", text: $password)
                                            .placeholder(when: password.isEmpty) {
                                                Text("Password")
                                                    .foregroundColor(Color("Greyscale500"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                            }
                                            .font(.custom("Urbanist-Bold", size: 20))
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
                                
                                if password != "" && password.count <= 8 {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("Your password is weak, try a better one")
                                            .foregroundColor(Color("Error"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .cornerRadius(10)
                                } else if password.count >= 8 && password.rangeOfCharacter(from: .uppercaseLetters) != nil && password.rangeOfCharacter(from: .lowercaseLetters) != nil && password.rangeOfCharacter(from: .decimalDigits) != nil {
                                    HStack(spacing: 6) {
                                        Image("green-alert")
                                            .padding(.leading, 12)
                                        Text("Your password is strong, it is able to defeat hackers")
                                            .foregroundColor(Color("Green"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentGreen"))
                                    .cornerRadius(10)
                                } else if password.count >= 8 {
                                    HStack(spacing: 6) {
                                        Image("yellow-alert")
                                            .padding(.leading, 12)
                                        Text("Your password is correct, but you can do better")
                                            .foregroundColor(Color("Orange"))
                                            .font(.custom("Urbanist-Semibold", size: 12))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentYellow"))
                                    .cornerRadius(10)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Confirm Password")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                HStack {
                                    if isConfirmPasswordHidden {
                                        SecureField("", text: $confirmPassword)
                                            .placeholder(when: confirmPassword.isEmpty) {
                                                Text("Confirm Password")
                                                    .foregroundColor(Color("Greyscale500"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                            }
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .foregroundColor(Color("Greyscale900"))
                                            .textContentType(.password)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    } else {
                                        TextField("", text: $confirmPassword)
                                            .placeholder(when: confirmPassword.isEmpty) {
                                                Text("Confirm Password")
                                                    .foregroundColor(Color("Greyscale500"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                            }
                                            .font(.custom("Urbanist-Bold", size: 20))
                                            .foregroundColor(Color("Greyscale900"))
                                            .textContentType(.password)
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    }
                                    Spacer()
                                    Button {
                                        isConfirmPasswordHidden.toggle()
                                    } label: {
                                        Image(isConfirmPasswordHidden == true ? "hidden-eye" : "eye")
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
                                
                                if passwordNotIdentical {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("Confirm password and password must be identical")
                                            .foregroundColor(Color("Error"))
                                            .font(.custom("Urbanist-Regular", size: 10))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .cornerRadius(10)
                                }
                            }
                            
                            Button {
                                isCheckboxChecked.toggle()
                            } label: {
                                HStack(spacing: 16) {
                                    Image(isCheckboxChecked ? "checkbox-checked" : "checkbox-unchecked")
                                    Text("Remember me")
                                        .foregroundColor(Color("Greyscale900"))
                                        .font(.custom("Urbanist-Semibold", size: 18))
                                }
                            }
                        }
                    }
                    .padding(.top, 40)
                }
                
                if username != "" && email != "" && password != "" && confirmPassword != "" {
                    if password == confirmPassword {
                        NavigationLink {
                            Text("Accueil")
                        } label: {
                            Text("Continue")
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
                    } else {
                        Button {
                            passwordNotIdentical = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                passwordNotIdentical = false
                            }
                        } label: {
                            Text("Continue")
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
                    }
                } else {
                    Text("Continue")
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
            .background(Color("White"))
            //.background(Color(red: 9/255, green: 16/255, blue: 29/255, opacity: 0.6))
            //.blur(radius: 4)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
                ToolbarItem(placement: .principal) {
                    Image("progress-bar-100")
                }
            }
            //ModalView()
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false), vegetarian: .constant(false), vegan: .constant(false), glutenFree: .constant(false), nutFree: .constant(false), dairyFree: .constant(false), lowCarb: .constant(false), peanutFree: .constant(false), keto: .constant(false), soyFree: .constant(false), rawFood: .constant(false), lowFat: .constant(false), halal: .constant(false), fullName: .constant("JK Rowling"), phoneNumber: .constant("0600000000"), gender: .constant("Male"), date: .constant("12/05/1997"), city: .constant("London"))
    }
}
