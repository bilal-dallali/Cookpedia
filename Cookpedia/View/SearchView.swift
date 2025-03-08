//
//  SearchView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 08/03/2025.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText: String = ""
    @FocusState private var isTextFocused: Bool
    @State private var isRecipeSelected: Bool = true
    @State private var isPeopleSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 12) {
                Image("Search - Regular - Light - Outline")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color("MyWhite"))
                    .padding(.leading, 20)
                TextField("", text: $searchText)
                    .foregroundStyle(Color("MyWhite"))
                    .font(.custom("Urbanist-Semibold", size: 16))
                    .keyboardType(.default)
                    .multilineTextAlignment(.leading)
                    .frame(height: 22)
                    .frame(maxWidth: .infinity)
                    .focused($isTextFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        //
                    }
                Button {
                    searchText = ""
                } label: {
                    Image("Icon=times, Component=Additional Icons")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color("MyWhite"))
                }
                .padding(.trailing, 20)
            }
            .frame(height: 58)
            .frame(maxWidth: .infinity)
            .background(Color("Dark2"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isTextFocused ? Color("Primary900") : Color.clear, lineWidth: 2)
            }
            HStack(spacing: 12) {
                Button {
                    isRecipeSelected = true
                    isPeopleSelected = false
                } label: {
                    if isRecipeSelected {
                        Text("Recipes")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    } else {
                        Text("Recipes")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Primary900"), lineWidth: 2)
                            }
                    }
                }
                
                Button {
                    isRecipeSelected = false
                    isPeopleSelected = true
                } label: {
                    if isPeopleSelected {
                        Text("People")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    } else {
                        Text("People")
                            .foregroundStyle(Color("Primary900"))
                            .font(.custom("Urbanist-Semibold", size: 16))
                            .frame(height: 38)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Primary900"), lineWidth: 2)
                            }
                    }
                }
            }
            
            ScrollView {
                Text("azerty")
            }
            .scrollIndicators(.hidden)

        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .background(Color("Dark1"))
        .onTapGesture {
            isTextFocused = false
        }
        .onAppear {
            //isTextFocused = true
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
        
    }
}

#Preview {
    SearchView()
}
