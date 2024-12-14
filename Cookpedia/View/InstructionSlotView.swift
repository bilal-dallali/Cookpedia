//
//  InstructionSlotView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 22/11/2024.
//

import SwiftUI

struct InstructionSlotView: View {
    
    @Binding var instruction: String
    @Binding var images: [UIImage]
    @Binding var instructionPictureUrl1: String?
    @Binding var instructionPictureUrl2: String?
    @Binding var instructionPictureUrl3: String?
    
    let onDelete: () -> Void
    let number: Int
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImageIndex: Int? = nil
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 4) {
                Image("drag-drop")
                    .resizable()
                    .frame(width: 24, height: 24)
                Circle()
                    .foregroundStyle(Color("Dark3"))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text("\(number)")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                    }
            }
            VStack(spacing: 8) {
                CustomTextEditor(text: $instruction, backgroundColor: UIColor(named: "Dark2") ?? .gray, textColor: UIColor(named: "MyWhite") ?? .white, font: UIFont(name: "Urbanist-Semibold", size: 16) ?? .systemFont(ofSize: 16), textPadding: UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15))
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .topLeading) {
                        if instruction.isEmpty {
                            Text("Instructions \(number)")
                                .foregroundStyle(Color("Greyscale500"))
                                .font(.custom("Urbanist-Regular", size: 16))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 18)
                        }
                    }
                HStack(spacing: 8) {
                    Button {
                        selectedImageIndex = 0
                        isImagePickerPresented = true
                    } label: {
                        VStack(spacing: 8) {
                            Image("image")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Add image")
                                .foregroundStyle(Color("Greyscale500"))
                                .font(.custom("Urbanist-Regular", size: 10))
                        }
                        .frame(height: 72)
                        .frame(maxWidth: .infinity)
                        .background(Color("Dark2"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            if images.indices.contains(0) {
                                GeometryReader { geometry in
                                    Image(uiImage: images[0])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 72)
                                        .frame(width: geometry.size.width, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    
                    Button {
                        selectedImageIndex = 1
                        isImagePickerPresented = true
                    } label: {
                        VStack(spacing: 8) {
                            Image("image")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Add image")
                                .foregroundStyle(Color("Greyscale500"))
                                .font(.custom("Urbanist-Regular", size: 10))
                        }
                        .frame(height: 72)
                        .frame(maxWidth: .infinity)
                        .background(Color("Dark2"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            if images.indices.contains(1) {
                                GeometryReader { geometry in
                                    Image(uiImage: images[1])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 72)
                                        .frame(width: geometry.size.width, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    
                    Button {
                        selectedImageIndex = 2
                        isImagePickerPresented = true
                    } label: {
                        VStack(spacing: 8) {
                            Image("image")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Add image")
                                .foregroundStyle(Color("Greyscale500"))
                                .font(.custom("Urbanist-Regular", size: 10))
                        }
                        .frame(height: 72)
                        .frame(maxWidth: .infinity)
                        .background(Color("Dark2"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            if images.indices.contains(2) {
                                GeometryReader { geometry in
                                    Image(uiImage: images[2])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 72)
                                        .frame(width: geometry.size.width, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    
                }
                
            }
            Button {
                onDelete()
            } label: {
                Image("delete")
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage) { fileName in
                if let selectedIndex = selectedImageIndex, let selectedImage = selectedImage {
                    if selectedIndex < images.count {
                        images[selectedIndex] = selectedImage
                    } else {
                        //images.append(selectedImage)
                        while images.count <= selectedIndex {
                            images.append(UIImage())
                        }
                        images[selectedIndex] = selectedImage
                    }
                    // Generate unique name and assign it
                    let uniqueFileName = generateUniqueImageName()
                    switch selectedIndex {
                    case 0: instructionPictureUrl1 = "instruction_picture_url_1_\(uniqueFileName)"
                    case 1: instructionPictureUrl2 = "instruction_picture_url_2_\(uniqueFileName)"
                    case 2: instructionPictureUrl3 = "instruction_picture_url_3_\(uniqueFileName)"
                    default: break
                    }
                }
            }
        }
    }
}

#Preview {
    InstructionSlotView(instruction: .constant(""), images: .constant([UIImage(named: "sweet-spicy-beef-soup-recipe")!, UIImage(named: "sweet-spicy-beef-soup-recipe")!, UIImage(named: "sweet-spicy-beef-soup-recipe")!]), instructionPictureUrl1: .constant(""), instructionPictureUrl2: .constant(""), instructionPictureUrl3: .constant(""), onDelete: { }, number: 0)
        .padding(.horizontal, 24)
}
