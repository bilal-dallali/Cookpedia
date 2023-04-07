//
//  CompleteProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/03/2023.
//

import SwiftUI

struct CompleteProfileView: View {
    
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
    
    
    @State var fullName = ""
    @State var phoneNumber = ""
    @State var gender = ""
    
    @State private var isDropDownMenuActivated: Bool = false
    @State private var phoneNumberInvalid: Bool = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var isShowingDate = false
    private var localDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: selectedDate)
    }
    
    @State var date: String = ""
    @State var city = ""
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Complete Your Profile 📋")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Don't worry, only you can see your personal data. No one else will be able to see it.")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Regular", size: 18))
                        }
                        
                        VStack(spacing: 24) {
                            HStack {
                                Spacer()
                                Button {
                                    //
                                } label: {
                                    ZStack {
                                        Image("ellipse")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image("edit-square")
                                            }
                                        }
                                    }
                                    .frame(width: 120, height: 120)
                                }
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Full Name")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $fullName)
                                    .placeholder(when: fullName.isEmpty) {
                                        Text("Full Name")
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
                                Text("Phone Number")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $phoneNumber)
                                    .placeholder(when: phoneNumber.isEmpty) {
                                        Text("Phone Number")
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
                                if phoneNumberInvalid {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
                                            .padding(.leading, 12)
                                        Text("Phone number invalid")
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
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Gender")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(alignment: .trailing, spacing: 2) {
                                    Button {
                                        isDropDownMenuActivated.toggle()
                                    } label: {
                                        VStack(spacing: 8) {
                                            HStack {
                                                Text(gender == "" ? "Gender" : gender)
                                                    .foregroundColor(gender == "" ? Color("Greyscale500") : Color("Greyscale900"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                                Spacer()
                                                Image(isDropDownMenuActivated ? "arrow-up" : "arrow-down")
                                            }
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(Color("Primary"))
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Date of Birth")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(spacing: 8) {
                                    Button {
                                        showDatePicker.toggle()
                                    } label: {
                                        HStack {
                                            Text(isShowingDate ? "\(localDate)" : "DD/MM/YYYY")
                                                .foregroundColor(Color(isShowingDate ? "Greyscale900" : "Greyscale500"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                            Spacer()
                                            Image("calendar")
                                        }
                                    }
                                    .sheet(isPresented: $showDatePicker) {
                                        VStack(spacing: 0) {
                                            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                                .datePickerStyle(.wheel)
                                                .padding()
                                                .frame(maxWidth: 50)
                                                .environment(\.locale, Locale(identifier: "fr_FR"))
                                            Button {
                                                showDatePicker = false
                                                isShowingDate = true
                                                print(localDate)
                                                print(selectedDate)
                                            } label: {
                                                Text("Ok")
                                                    .foregroundColor(Color("White"))
                                                    .font(.custom("Urbanist-Bold", size: 16))
                                                    .frame(width: 80)
                                                    .frame(height: 58)
                                                    .background(Color("Primary"))
                                                    .cornerRadius(.infinity)
                                                    .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 4, x: 4, y: 8)
                                            }
                                        }
                                        .presentationDetents([.height(270)])
                                    }
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            Text("City")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            TextField("", text: $city)
                                .placeholder(when: city.isEmpty) {
                                    Text("City")
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
                    }
                    .padding(.top, 40)
                }
                
                if fullName != "" && phoneNumber != "" &&  isShowingDate && city != "" {
                    if phoneNumber.count == 10, phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                        NavigationLink {
                            CreateAccountView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit, vegetarian: $vegetarian, vegan: $vegan, glutenFree: $glutenFree, nutFree: $nutFree, dairyFree: $dairyFree, lowCarb: $lowCarb, peanutFree: $peanutFree, keto: $keto, soyFree: $soyFree, rawFood: $rawFood, lowFat: $lowFat, halal: $halal, fullName: $fullName, phoneNumber: $phoneNumber, gender: $gender, date: $date, city: $city)
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
                        .onAppear {
                            date = localDate
                        }
                    } else {
                        Button {
                            phoneNumberInvalid = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                phoneNumberInvalid = false
                            }
                            print(localDate)
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
                    //.shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 4, x: 4, y: 8)
                        .padding(.top, 24)
                        .padding(.bottom)
                }
            }
            .padding(.horizontal, 24)
            .background(Color("White"))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
                ToolbarItem(placement: .principal) {
                    Image("progress-bar-80")
                }
            }
            .onTapGesture {
                isDropDownMenuActivated = false
            }
            if isDropDownMenuActivated {
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        gender = "Male"
                        isDropDownMenuActivated = false
                    } label: {
                        HStack {
                            Image(gender == "Male" ? "radio-selected" : "radio-unselected")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Male")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Semibold", size: 14))
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    Button {
                        gender = "Female"
                        isDropDownMenuActivated = false
                    } label: {
                        HStack {
                            Image(gender == "Female" ? "radio-selected" : "radio-unselected")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Female")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Semibold", size: 14))
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .frame(width: 148)
                .background(Color("White"))
                .cornerRadius(20)
                .shadow(color: Color(red: 4/255, green: 6/255, blue: 15/255, opacity: 0.08), radius: 100, x: 0, y: 20)
                .padding(.top, 300)
            }
        }
    }
}

struct CompleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteProfileView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false), vegetarian: .constant(false), vegan: .constant(false), glutenFree: .constant(false), nutFree: .constant(false), dairyFree: .constant(false), lowCarb: .constant(false), peanutFree: .constant(false), keto: .constant(false), soyFree: .constant(false), rawFood: .constant(false), lowFat: .constant(false), halal: .constant(false))
    }
}
