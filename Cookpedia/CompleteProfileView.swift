//
//  CompleteProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/03/2023.
//

import SwiftUI

struct CompleteProfileView: View {
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var gender = ""
    @State private var isDropDownMenuActivated: Bool = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var isShowingDate = false
    private var date: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: selectedDate)
    }
    var body: some View {
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
                                Image("avatar")
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
                            //.focused($emailFieldIsFocused)
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
                                .font(Font.custom("Urbanist-Bold", size: 20))
                                .foregroundColor(Color("Greyscale900"))
                            //.focused($emailFieldIsFocused)
                                .frame(height: 41)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Primary"))
                                        .padding(.top), alignment: .bottom
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Gender")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 16))
                            VStack(spacing: 8) {
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
                                
                                if isDropDownMenuActivated {
                                    VStack(spacing: 8) {
                                        Button {
                                            gender = "Male"
                                            isDropDownMenuActivated = false
                                        } label: {
                                            HStack {
                                                Text("Male")
                                                    .foregroundColor(Color("Greyscale900"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                                Spacer()
                                            }
                                        }
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .foregroundColor(Color("Primary"))
                                                    .frame(height: 1)
                                            }
                                        Button {
                                            gender = "Female"
                                            isDropDownMenuActivated = false
                                        } label: {
                                            HStack {
                                                Text("Female")
                                                    .foregroundColor(Color("Greyscale900"))
                                                    .font(.custom("Urbanist-Bold", size: 20))
                                                Spacer()
                                            }
                                        }
                                        Divider()
                                            .overlay {
                                                Rectangle()
                                                    .foregroundColor(Color("Primary"))
                                                    .frame(height: 1)
                                            }
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
                                        Text(isShowingDate ? "\(date)" : "DD/MM/YYYY")
                                            .foregroundColor(Color(isShowingDate ? "Greyscale900" : "Greyscale500"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                        Spacer()
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color("Primary"))
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
                                            print(date)
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
                }
                .padding(.top, 40)
            }
            
            Button {
                print("full name:", fullName)
                print("phone number:", phoneNumber)
                print("gender:", gender)
                print("date:", date)
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-80")
            }
        }
    }
    
    
}

struct CompleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteProfileView()
    }
}
