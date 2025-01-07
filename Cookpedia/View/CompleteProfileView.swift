//
//  CompleteProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/10/2024.
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
    
    @State var profilePictureUrl: String = ""
    @State var fullName = ""
    @State var phoneNumber = ""
    @State var gender = ""
    @State var selectedImage: UIImage?
    
    @State private var isImagePickerPresented = false
    
    @State private var isDropDownMenuActivated: Bool = false
    @State private var phoneNumberInvalid: Bool = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var isShowingDate = false
    @FocusState private var isTextFocused: Bool
    
    private var localDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: selectedDate)
    }
    
    @State var date: String = ""
    @State var city = ""
    @State private var progressViewWidth: CGFloat = 132
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Complete Your Profile 📋")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 32))
                            Text("Don't worry, only you can see your personal data. No one else will be able to see it.")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-regular", size: 18))
                        }
                        
                        VStack(spacing: 24) {
                            HStack {
                                Spacer()
                                Button {
                                    isImagePickerPresented = true
                                } label: {
                                    if let selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .frame(width: 120, height: 120)
                                            .clipShape(.rect(cornerRadius: .infinity))
                                            .overlay(alignment: .trailingLastTextBaseline) {
                                                Image("Edit Square - Regular - Bold")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundStyle(Color("Primary900"))
                                            }
                                    } else {
                                        Image("Ellipse")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .clipShape(.rect(cornerRadius: .infinity))
                                            .overlay(alignment: .trailingLastTextBaseline) {
                                                Image("Edit Square - Regular - Bold")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundStyle(Color("Primary900"))
                                            }
                                    }
                                }
                                .sheet(isPresented: $isImagePickerPresented) {
                                    ImagePicker(image: $selectedImage) { filename in
                                        profilePictureUrl = "profile_picture_\(filename)"
                                    }
                                }
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Full Name")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(spacing: 8) {
                                    TextField(text: $fullName) {
                                        Text("Full Name")
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
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Phone Number")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(spacing: 8) {
                                    TextField(text: $phoneNumber) {
                                        Text("Phone Number")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.numberPad)
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(height: 32)
                                    .focused($isTextFocused)
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                                if phoneNumberInvalid {
                                    HStack(spacing: 6) {
                                        Image("Info Circle - Regular - Bold")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color("Error"))
                                            .padding(.leading, 12)
                                        Text("Phone number invalid")
                                            .foregroundStyle(Color("Error"))
                                            .font(.custom("Urbanist-Regular", size: 10))
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 34)
                                    .background(Color("TransparentRed"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Gender")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                Button {
                                    isDropDownMenuActivated.toggle()
                                } label: {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text(gender == "" ? "Gender" : gender)
                                                .foregroundStyle(gender == "" ? Color("Dark4") : Color("MyWhite"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                            Spacer()
                                            Image(isDropDownMenuActivated ? "Arrow - Up 2 - Regular - Light - Outline" : "Arrow - Down 2 - Regular - Light - Outline")
                                                .resizable()
                                                .frame(width: 28, height: 28)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                        .frame(height: 32)
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Date of Birth")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(spacing: 8) {
                                    Button {
                                        showDatePicker.toggle()
                                    } label: {
                                        HStack {
                                            Text(isShowingDate ? localDate : "DD/MM/YYYY")
                                                .foregroundStyle(Color(isShowingDate ? "MyWhite" : "Dark4"))
                                                .font(.custom("Urbanist-Bold", size: 20))
                                            Spacer()
                                            Image("Calendar - Regular - Bold")
                                                .resizable()
                                                .frame(width: 28, height: 28)
                                                .foregroundStyle(Color("Primary900"))
                                        }
                                        .frame(height: 32)
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
                                            } label: {
                                                Text("Done")
                                                    .foregroundStyle(Color("MyWhite"))
                                                    .font(.custom("Urbanist-Bold", size: 16))
                                                    .frame(width: 80, height: 58)
                                                    .background(Color("Primary900"))
                                                    .clipShape(.rect(cornerRadius: .infinity))
                                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                                            }
                                        }
                                        .presentationDetents([.height(270)])
                                        .frame(maxWidth: .infinity)
                                        .background(Color("Dark2"))
                                    }
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color("Primary900"))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("City")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                VStack(spacing: 8) {
                                    TextField(text: $city) {
                                        Text("City")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.default)
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .frame(height: 32)
                                    .focused($isTextFocused)
                                    .onSubmit {}
                                    Rectangle()
                                        .foregroundStyle(Color("Primary900"))
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .scrollIndicators(.hidden)
                
                VStack(spacing: 0) {
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    if fullName != "" && phoneNumber != "" && isShowingDate && city != "" {
                        if phoneNumber.count == 10, phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                            NavigationLink {
                                CreateAccountView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit, vegetarian: $vegetarian, vegan: $vegan, glutenFree: $glutenFree, nutFree: $nutFree, dairyFree: $dairyFree, lowCarb: $lowCarb, peanutFree: $peanutFree, keto: $keto, soyFree: $soyFree, rawFood: $rawFood, lowFat: $lowFat, halal: $halal, fullName: $fullName, phoneNumber: $phoneNumber, gender: $gender, date: $date, city: $city, profilePictureUrl: $profilePictureUrl, selectedImage: $selectedImage)
                            } label: {
                                Text("Continue")
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
                            .onAppear {
                                date = localDate
                            }
                        } else {
                            Button {
                                phoneNumberInvalid = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    phoneNumberInvalid = false
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
                            .clipShape(.rect(cornerRadius: .infinity))
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 36)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation(.easeIn(duration: 1)) {
                        progressViewWidth = 168
                    }
                }
            }
            .background(Color("Dark1"))
            .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
                ToolbarItem(placement: .principal) {
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundStyle(Color("Dark4"))
                        .frame(width: 216, height: 12)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: .infinity)
                                .foregroundStyle(Color("Primary900"))
                                .frame(width: progressViewWidth, height: 12)
                        }
                }
            }
            .onTapGesture {
                isDropDownMenuActivated = false
                isTextFocused = false
            }
            
            if isDropDownMenuActivated {
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        gender = "Male"
                        isDropDownMenuActivated = false
                    } label: {
                        Image(gender == "Male" ? "selected-radio" : "unselected-radio")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Male")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 14))
                        Spacer()
                    }
                    
                    Divider()
                        .overlay {
                            Rectangle()
                                .strokeBorder(Color("Dark4"), lineWidth: 1)
                        }
                    
                    Button {
                        gender = "Female"
                        isDropDownMenuActivated = false
                    } label: {
                        Image(gender == "Female" ? "selected-radio" : "unselected-radio")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Female")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 14))
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
                .frame(width: 300)
                .background(Color("Dark2"))
                .clipShape(.rect(cornerRadius: 20))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color("Dark4"), lineWidth: 1)
                }
            }
        }
    }
}

#Preview {
    CompleteProfileView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false), vegetarian: .constant(false), vegan: .constant(false), glutenFree: .constant(false), nutFree: .constant(false), dairyFree: .constant(false), lowCarb: .constant(false), peanutFree: .constant(false), keto: .constant(false), soyFree: .constant(false), rawFood: .constant(false), lowFat: .constant(false), halal: .constant(false))
}
