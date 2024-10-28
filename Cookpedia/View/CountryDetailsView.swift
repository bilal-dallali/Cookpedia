//
//  CountryDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI

struct CountryDetailsView: View {
    
    let country: Country
    @Binding var selectedCountry: Country?
    var isCountrySelected: Bool {
        selectedCountry == country
    }
    
    var body: some View {
        Button {
            selectedCountry = isCountrySelected ? nil : country
        } label: {
            HStack(spacing: 16) {
                HStack(spacing: 16) {
                    Image(country.flag)
                        .resizable()
                        .frame(width: 48, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(country.domain)
                        .foregroundStyle(Color("Greyscale300"))
                        .frame(width: 36)
                        .font(.custom("Urbanist-SemiBold", size: 18))
                    Text(country.name)
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 18))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                .padding(20)
                .background(Color("Dark2"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay {
                    if isCountrySelected {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color("Primary900"), lineWidth: 2)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color("Dark4"), lineWidth: 1)
                    }
                }
                
            }
        }
    }
}

#Preview {
    CountryDetailsView(country: .init(name: "Algérie", flag: "algeria", domain: "DZ"), selectedCountry: .constant(nil))
        .padding(24)
}
