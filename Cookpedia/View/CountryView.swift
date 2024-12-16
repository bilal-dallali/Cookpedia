//
//  CountryView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct CountryView: View {
    
    @State private var selectedCountry: Country?
    @State private var searchText: String = ""
    @State var country: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countryList
        } else {
            return countryList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Which country are you from? 🏳️")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Please select your country of origin for a better recommendations.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    HStack(spacing: 12) {
                        if isTextFieldFocused {
                            Image("magnifying-glass-focused")
                                .padding(.leading, 20)
                        } else {
                            Image("magnifying-glass-inactive")
                                .padding(.leading, 20)
                        }
                        TextField("", text: $searchText)
                            .padding(.trailing, 20)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                            .focused($isTextFieldFocused)
                            .overlay(alignment: .bottomLeading) {
                                Text(isTextFieldFocused == false && searchText.isEmpty ? "Search Country" : "")
                                    .foregroundStyle(Color("Greyscale600"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                            }
                    }
                    .frame(height: 58)
                    .background(Color("Dark2"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(spacing: 20) {
                        ForEach(filteredCountries, id: \.name) { country in
                            CountryDetailsView(country: country, selectedCountry: $selectedCountry)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 24)
            
            
            Divider()
                .overlay {
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color("Dark4"))
                }
            VStack {
                if selectedCountry != nil {
                    NavigationLink {
                        CookingLevelView(country: $country)
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
                        country = selectedCountry?.name ?? ""
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
        .onAppear {
            country = selectedCountry?.name ?? ""
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-22")
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

#Preview {
    CountryView()
}
