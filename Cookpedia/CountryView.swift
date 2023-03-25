//
//  CountryView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 11/03/2023.
//

import SwiftUI

struct CountryView: View {
    
    @State private var country = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            NavigationLink(destination: WelcomeView()) {
                                Image("arrow-left")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color("Greyscale900"))
                                    .padding(.vertical, 10)
                            }
                            .padding(.trailing, 55)
                            Image("progress-bar-22")
                            Spacer()
                        }
                        
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Which country are you from? 🏳️")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-Bold", size: 32))
                                Text("Please select your country of origin for a better recommendations.")
                                    .font(.custom("Urbanist-Regular", size: 18))
                            }
                            
                            HStack(spacing: 12) {
                                Image("magnifying-glass")
                                    .padding(.leading, 20)
                                TextField("Search Country", text: $country)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
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
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
                Button {
                    //
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .foregroundColor(Color("White"))
                            .frame(height: 58)
                            .font(.custom("Urbanist-Bold", size: 16))
                        Spacer()
                    }
                    .background(Color("DisButton"))
                    .cornerRadius(.infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom)
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView()
    }
}
