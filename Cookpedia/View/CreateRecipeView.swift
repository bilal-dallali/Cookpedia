//
//  CreateRecipeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 18/11/2024.
//

import SwiftUI

struct CreateRecipeView: View {
    
    @State private var title = ""
    @State private var description = ""
    
    @Binding var isCreateRecipeSelected: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    HStack(spacing: 16) {
                        Button {
                            isCreateRecipeSelected = false
                        } label: {
                            Image("mark")
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        Text("Create Recipe")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 24))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    Spacer()
                    HStack(spacing: 12) {
                        Button {
                            //
                        } label: {
                            Text("Save")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(width: 77, height: 38)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                        Button {
                            //
                        } label: {
                            Text("Publish")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Semibold", size: 16))
                                .frame(width: 91, height: 38)
                                .overlay {
                                    RoundedRectangle(cornerRadius: .infinity)
                                        .strokeBorder(Color("Primary900"), lineWidth: 2)
                                }
                        }
                        Button {
                            //
                        } label: {
                            Image("more-circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }

                    }
                }
                Button {
                    print("add image")
                } label: {
                    VStack(spacing: 32) {
                        Image("image")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Add recipe cover image")
                            .foregroundStyle(Color("Greyscale500"))
                            .font(.custom("Urbanist-Regular", size: 16))
                    }
                    .frame(height: 382)
                    .frame(maxWidth: .infinity)
                    .background(Color("Dark2"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                    }
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text("Title")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 20))
                    TextField("", text: $title)
                        .placeholder(when: title.isEmpty) {
                            Text("Recipe Title")
                                .foregroundStyle(Color("Greyscale500"))
                                .font(.custom("Urbanist-Regular", size: 16))
                        }
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Semibold", size: 16))
                        .padding(.leading, 20)
                        .frame(height: 58)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("Dark2"))
                        }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Description")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 20))
                    CustomTextEditor(text: $description, backgroundColor: UIColor(named: "Dark2") ?? .gray, textColor: UIColor(named: "MyWhite") ?? .white, font: UIFont(name: "Urbanist-Semibold", size: 16) ?? .systemFont(ofSize: 16), textPadding: UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15))
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        if description.isEmpty {
                            VStack {
                                HStack {
                                    Text("Lorem ipsum dolor sit amet ...")
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
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 24)
        }
        .background(Color("Dark1"))
        
    }
}

#Preview {
    CreateRecipeView(isCreateRecipeSelected: .constant(true))
}
