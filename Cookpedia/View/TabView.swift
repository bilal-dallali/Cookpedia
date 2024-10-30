//
//  TabView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI

struct TabView: View {
    
    @State private var isHomeSelected: Bool = true
    @State private var isDiscoverSelected: Bool = false
    @State private var isMyRecipeSelected: Bool = false
    @State private var isMyProfileSelected: Bool = false
    
    var body: some View {
        ZStack {
            HomePageView()
            
            
            
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 19) {
                        Button {
                            //
                        } label: {
                            VStack(spacing: 2) {
                                Image(isHomeSelected ? "house-selected" : "house")
                                Text("Home")
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 20))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            //
                        } label: {
                            VStack(spacing: 2) {
                                Image(isHomeSelected ? "house-selected" : "house")
                                Text("Home")
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 20))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            //
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(width: 38, height: 38)
                                    .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                                Image(systemName: "plus")
                                    .foregroundColor(Color("MyWhite"))
                                    .frame(width: 12, height: 12)
                            }
                            .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                        }
                        
                        Button {
                            //
                        } label: {
                            VStack(spacing: 2) {
                                Image(isHomeSelected ? "house-selected" : "house")
                                Text("Home")
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 20))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            //
                        } label: {
                            VStack(spacing: 2) {
                                Image(isHomeSelected ? "house-selected" : "house")
                                Text("Home")
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 20))
                            }
                        }
                        .frame(maxWidth: .infinity)

                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 5)
                }
                .padding(.top, 8)
                .padding(.bottom, 29)
                .background {
                    Rectangle()
                        .fill(Color("MyBlue"))
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    TabView()
}
