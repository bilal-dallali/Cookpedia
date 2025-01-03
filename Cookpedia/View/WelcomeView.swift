//
//  WelcomeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 32) {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            Text("Welcome to ")
                                .font(.custom("Urbanist-Bold", size: 40))
                                .foregroundStyle(Color("MyWhite"))
                            Text("Cookpedia 👋 ")
                                .font(.custom("Urbanist-Bold", size: 40))
                                .foregroundStyle(Color("Primary900"))
                        }
                        Text("The best cooking and food recipes app of the century.")
                            .foregroundColor(Color("MyWhite"))
                            .multilineTextAlignment(.center)
                            .font(.custom("Urbanist-Medium", size: 20))
                            .lineSpacing(10)
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    VStack(spacing: 24) {
                        NavigationLink {
                            CountryView()
                        } label: {
                            Text("Get Started")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("urbanist-SemiBold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("I Already Have an Account")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
                                .background(Color("Dark4"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                    }
                }
                .padding(.horizontal, 48)
                .padding(.top, 13)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WelcomeView()
}
