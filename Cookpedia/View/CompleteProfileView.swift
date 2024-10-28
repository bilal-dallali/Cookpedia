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
    return "profile_\(uuid).jpg"
}

//func generateUniqueImageName() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyyMMddHHmmss"
//    let dateString = dateFormatter.string(from: Date())
//    return "profile_\(dateString).jpg"
//}

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
        VStack {
            ZStack {
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
                                            .padding(.top, 32)
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Phone Number")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Bold", size: 16))
                                TextField("", text: $phoneNumber)
                                    .placeholder(when: phoneNumber.isEmpty) {
                                        Text("0700000000")
                                            .foregroundStyle(Color("Dark4"))
                                            .font(.custom("Urbanist-Bold", size: 20))
                                    }
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.numberPad)
                                    .font(.custom("Urbanist-Bold", size: 20))
                                    .foregroundStyle(Color("MyWhite"))
                                    .frame(height: 41)
                                    .overlay {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("Primary900"))
                                            .padding(.top, 32)
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
                            print(profilePictureUrl)
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
                Image("progress-bar-80")
            }
        }
    }
}

#Preview {
    CompleteProfileView(country: .constant("France"), level: .constant("Novice"), salad: .constant(false), egg: .constant(false), soup: .constant(false), meat: .constant(false), chicken: .constant(false), seafood: .constant(false), burger: .constant(false), pizza: .constant(false), sushi: .constant(false), rice: .constant(false), bread: .constant(false), fruit: .constant(false), vegetarian: .constant(false), vegan: .constant(false), glutenFree: .constant(false), nutFree: .constant(false), dairyFree: .constant(false), lowCarb: .constant(false), peanutFree: .constant(false), keto: .constant(false), soyFree: .constant(false), rawFood: .constant(false), lowFat: .constant(false), halal: .constant(false))
}
