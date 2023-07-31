//
//  DiscoverPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 12/04/2023.
//

import SwiftUI

struct DiscoverPageView: View {
    
    @State private var searchRecipes: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("Discover")
                                .foregroundColor(Color("Greyscale900"))
                                .font(.custom("Urbanist-Bold", size: 24))
                                .padding(.leading, 16)
                            Spacer()
                            Button {
                                //
                            } label: {
                                Image("more-circle")
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 28) {
                            HStack(spacing: 12) {
                                Image("magnifying-glass")
                                    .padding(.leading, 20)
                                TextField("", text: $searchRecipes)
                                    .placeholder(when: searchRecipes.isEmpty) {
                                        Text("Search for Recipes or Chef")
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
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 16)
                }
                .background(Color("White"))
            }
        }
    }
}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView()
    }
}
