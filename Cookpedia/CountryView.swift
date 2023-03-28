//
//  CountryView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/03/2023.
//

import SwiftUI

struct CountryView: View {
    
    @State private var country = ""
    @State private var isCountrySelected: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
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
                        TextField("Search Country", text: $country)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .foregroundColor(Color("Greyscale400"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    .frame(height: 58)
                    .background(Color("Greyscale100"))
                    .cornerRadius(16)
                    
                    VStack(spacing: 20) {
                        ForEach(countryList, id: \.name) { country in
                            CountryDetailsView(country: country)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .padding(.top, 40)
            }
            
            NavigationLink {
                CookingLevelView()
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
        }
        .padding(.horizontal, 24)
        .background(Color("White"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
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
