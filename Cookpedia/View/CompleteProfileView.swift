//
//  CompleteProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 28/10/2024.
//

import SwiftUI
import PhotosUI

func generateUniqueImageName() -> String {
    let uuid = UUID().uuidString
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    let dateString = dateFormatter.string(from: Date())
    return "profile_\(dateString)_\(uuid).jpg"
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var profilePictureUrl: String
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.parent.selectedImage = image
                            let uniqueImageName = generateUniqueImageName()
                            self.parent.profilePictureUrl = uniqueImageName
                        }
                    }
                }
            }
        }
    }
}

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
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
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
                                    ZStack {
                                        if let selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .frame(width: 120, height: 120)
                                                .clipShape(.rect(cornerRadius: .infinity))
                                        }
                                        else {
                                            Image("ellipse")
                                                .resizable()
                                                .frame(width: 120, height: 120)
                                                .clipShape(.rect(cornerRadius: .infinity))
                                        }
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
                                .sheet(isPresented: $isImagePickerPresented) {
                                    PhotoPicker(selectedImage: $selectedImage, profilePictureUrl: $profilePictureUrl)
                                }
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Name")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $fullName)
                                    .placeholder(when: fullName.isEmpty) {
                                        Text("Full Name")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.default)
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .foregroundStyle(Color("MyWhite"))
                                    .frame(height: 41)
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                            .padding(.top, 40)
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Phone Number")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $phoneNumber)
                                    .placeholder(when: phoneNumber.isEmpty) {
                                        Text("Phone Number")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.numberPad)
                                    .scrollDismissesKeyboard(.immediately)
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .foregroundStyle(Color("MyWhite"))
                                    .frame(height: 41)
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                            .padding(.top, 40)
                                    }
                                if phoneNumberInvalid {
                                    HStack(spacing: 6) {
                                        Image("red-alert")
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
                            
                            VStack(alignment: .leading, spacing: 8) {
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
                                            Image(isDropDownMenuActivated ? "arrow-up" : "arrow-down")
                                        }
                                        
                                        
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                    }
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("City")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $city)
                                    .placeholder(when: city.isEmpty) {
                                        Text("City")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.default)
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .foregroundStyle(Color("MyWhite"))
                                    .frame(height: 41)
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                            .padding(.top, 40)
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
                    if fullName != "" && phoneNumber != "" && isShowingDate && city != "" {
                        if phoneNumber.count == 10, phoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                            NavigationLink {
                                //print(profilePictureUrl)
                                //print(date)
                                CreateAccountView(country: $country, level: $level, salad: $salad, egg: $egg, soup: $soup, meat: $meat, chicken: $chicken, seafood: $seafood, burger: $burger, pizza: $pizza, sushi: $sushi, rice: $rice, bread: $bread, fruit: $fruit, vegetarian: $vegetarian, vegan: $vegan, glutenFree: $glutenFree, nutFree: $nutFree, dairyFree: $dairyFree, lowCarb: $lowCarb, peanutFree: $peanutFree, keto: $keto, soyFree: $soyFree, rawFood: $rawFood, lowFat: $lowFat, halal: $halal, fullName: $fullName, phoneNumber: $phoneNumber, gender: $gender, date: $date, city: $city, profilePictureUrl: $profilePictureUrl)
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
            .background(Color("Dark1"))
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
                        Image(gender == "Male" ? "radio-selected" : "radio-unselected")
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
                        Image(gender == "Female" ? "radio-selected" : "radio-unselected")
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
