//
//  CountryView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/03/2023.
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

struct CountryView: View {
    
    @State private var selectedCountry: Country?
    @State private var searchText: String = ""
    @State var country: String = ""
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countryList
        } else {
            return countryList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Which country are you from? 🏳️")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("Please select your country of origin for a better recommendations.")
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    
                    HStack(spacing: 12) {
                        Image("magnifying-glass")
                            .padding(.leading, 20)
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search Country")
                                    .foregroundColor(Color("Greyscale400"))
                                    .font(.custom("Urbanist-Regular", size: 16))
                            }
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(Color("Greyscale900"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    .frame(height: 58)
                    .background(Color("Greyscale100"))
                    .cornerRadius(16)
                    
                    VStack(spacing: 20) {
                        ForEach(filteredCountries, id: \.name) { country in
                            CountryDetailsView(country: country, selectedCountry: $selectedCountry)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .padding(.top, 40)
            }
            if selectedCountry != nil {
                NavigationLink {
                    CookingLevelView(country: $country)
                    //print("Selected country: \(selectedCountry?.name ?? "None")")
                    //print(country)
                } label: {
                    Text("Continue")
                        .foregroundColor(Color("White"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("Primary"))
                        .cornerRadius(.infinity)
                        .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 4, x: 4, y: 8)
                        .padding(.top, 24)
                        .padding(.bottom)
                }
                .onAppear {
                    country = selectedCountry?.name ?? ""
                }
            } else {
                Button {
                    //CookingLevelView()
                    print("Selected country: \(selectedCountry?.name ?? "None")")
                } label: {
                    Text("Continue")
                        .foregroundColor(Color("White"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .cornerRadius(.infinity)
                        .padding(.top, 24)
                        .padding(.bottom)
                }
            }
        }
        .onAppear {
            country = selectedCountry?.name ?? ""
        }
        .padding(.horizontal, 24)
        .background(Color("White"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Image("progress-bar-22")
            }
        }
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView()
    }
}
