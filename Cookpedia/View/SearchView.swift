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
        VStack {
            ScrollView {
                Text("Search view")
            }
            .scrollIndicators(.hidden)
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
                    .padding(.top, 16)
            }
            ToolbarItem(placement: .principal) {
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
                .padding(.top, 16)
            }
        }
        .onTapGesture {
            isTextFocused = false
        }
        .onAppear {
            isTextFocused = true
        }
    }
}

#Preview {
    SearchView()
}
