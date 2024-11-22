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
    let onDelete: (Int) -> Void
    let index: Int
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImageIndex: Int? = nil
    
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
                        Text("\(index + 1)")
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
                                    Text("Instructions \(index + 1)")
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
                onDelete(index)
            } label: {
                Image("delete")
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            if let index = selectedImageIndex {
                ImagePicker(image: Binding(
                    get: { images[safe: index] },
                    set: { value in
                        if let value = value {
                            if index < images.count {
                                images[index] = value
                            } else {
                                images.append(value)
                            }
                        }
                    }
                )) { _ in }
            }
        }
    }
}

#Preview {
    InstructionSlotView(instruction: .constant("."), images: .constant([
            UIImage(named: "profile-picture")!,
            UIImage(named: "profile-picture")!
        ]),
        onDelete: { _ in print("Delete tapped") }, index: 0)
}
