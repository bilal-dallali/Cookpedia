//
//  CountryView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

struct CountryView: View {
    
    @State private var selectedCountry: Country?
    @State private var searchText: String = ""
    @State var country: String = ""
    @FocusState private var isTextFocused: Bool
    
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
                        Image("Search - Regular - Light - Outline")
                            .foregroundStyle(Color(searchText.isEmpty ? "Greyscale600" : "MyWhite"))
                            .frame(width: 20, height: 20)
                            .padding(.leading, 20)
                        TextField(text: $searchText) {
                            Text("Search Country")
                                .foregroundStyle(Color("Greyscale600"))
                                .font(.custom("Urbanist-Regular", size: 16))
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.default)
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Regular", size: 18))
                        .padding(.trailing, 20)
                        .focused($isTextFocused)
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
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
            
            VStack(spacing: 0) {
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color("Dark4"))
                    }
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
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 36)
                        
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
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 36)
                }
            }
            
        }
        .onAppear {
            country = selectedCountry?.name ?? ""
        }
        .background(Color("Dark1"))
        .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                RoundedRectangle(cornerRadius: .infinity)
                    .foregroundStyle(Color("Dark4"))
                    .frame(width: 216, height: 12)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: .infinity)
                            .foregroundStyle(Color("Primary900"))
                            .frame(width: 48, height: 12)
                    }
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
