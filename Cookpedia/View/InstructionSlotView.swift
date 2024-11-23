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
    @Binding var instructionPicture1: String?
    @Binding var instructionPicture2: String?
    @Binding var instructionPicture3: String?
    
    let onDelete: () -> Void
    var number: Int
    
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
                    .overlay {
                        if instruction.isEmpty {
                            VStack {
                                HStack {
                                    Text("Instructions \(number)")
                                        .foregroundStyle(Color("Greyscale500"))
                                        .font(.custom("Urbanist-Regular", size: 16))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 18)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { imageIndex in
                        Button {
                            selectedImageIndex = imageIndex
                            isImagePickerPresented = true
                        } label: {
                            if imageIndex < images.count {
                                Image(uiImage: images[imageIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 72)
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Dark2"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                                    }
                            } else {
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
                        images.append(selectedImage)
                    }
                    // Generate unique name and assign it
                    let fileName = generateUniqueImageName()
                    switch selectedIndex {
                    case 0: instructionPicture1 = "instruction_picture_1_\(fileName)"
                    case 1: instructionPicture2 = "instruction_picture_2_\(fileName)"
                    case 2: instructionPicture3 = "instruction_picture_3_\(fileName)"
                    default: break
                    }
                }
            }
        }
    }
}

#Preview {
    InstructionSlotView(instruction: .constant(""), images: .constant([UIImage(named: "profile-picture")!, UIImage(named: "profile-picture")!, UIImage(named: "profile-picture")!]), instructionPicture1: .constant(""), instructionPicture2: .constant(""), instructionPicture3: .constant(""), onDelete: {  print("Delete tapped") }, number: 0)
}
