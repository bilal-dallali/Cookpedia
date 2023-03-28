//
//  CountryViewDetails.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/03/2023.
//

import SwiftUI

struct CountryDetailsView: View {
    
    let country: Country
    @State private var isCountrySelected: Bool = false
    
    var body: some View {
        Button {
            isCountrySelected.toggle()
        } label: {
            HStack(spacing: 23) {
                Image(country.flag)
                    .resizable()
                    .frame(width: 48, height: 32)
                    .cornerRadius(6)
                Text(country.domain)
                    .foregroundColor(Color("Greyscale600"))
                    .font(.custom("Urbanist-Semibold", size: 18))
                Text(country.name)
                    .foregroundColor(Color("Greyscale900"))
                    .font(.custom("Urbanist-Bold", size: 18))
                Spacer()
            }
            .padding(20)
            .overlay {
                if isCountrySelected == false {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("Greyscale200"))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("Primary"), lineWidth: 2)
                }
            }
        }
    }
}

struct CountryViewDetails_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailsView(country: countryList[3])
            .previewLayout(.sizeThatFits)
            .padding(24)
    }
}
