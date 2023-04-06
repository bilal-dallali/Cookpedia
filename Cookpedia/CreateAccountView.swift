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
    @State var password = ""
    @State var confirmPassword = ""
    
    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    @State private var isCheckboxChecked: Bool = true
    @State private var alertPasswordIdentical: Bool = true
    
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
                
                Button {
                    print("pays:", country)
                    print("niveau:", level)
                    print("salad:", salad)
                    print("egg:", egg)
                    print("soup:", soup)
                    print("meat:", meat)
                    print("chicken:", chicken)
                    print("seafood:", seafood)
                    print("burger:", burger)
                    print("pizza:", pizza)
                    print("sushi:", sushi)
                    print("bread:", bread)
                    print("rice:", rice)
                    print("fruit:", fruit)
                    print("vegetarian:", vegetarian)
                    print("vegan:", vegan)
                    print("gluten-free:", glutenFree)
                    print("nut-free:", nutFree)
                    print("dairy-free:", dairyFree)
                    print("low-carb:", lowCarb)
                    print("peanut-free:", peanutFree)
                    print("keto:", keto)
                    print("soy-free:", soyFree)
                    print("raw-food:", rawFood)
                    print("low-fat:", lowFat)
                    print("halal:", halal)
                    print("full name:", fullName)
                    print("phone number:", phoneNumber)
                    print("gender:", gender)
                    print("date-of-birth:", date)
                    print("city:", city)
                    print("username:", username)
                    print("email:", email)
                    print("password:", password)
                    print("confirmPassword", confirmPassword)
                } label: {
                    Text("Continue")
                        .foregroundColor(Color("White"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .cornerRadius(.infinity)
                    //.shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 4, x: 4, y: 8)
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
