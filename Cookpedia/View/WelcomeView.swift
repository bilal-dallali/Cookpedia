//
//  WelcomeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI

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
                                .foregroundStyle(Color("MyPrimary"))
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
                        Button {
                            print("continue with google")
                        } label: {
                            HStack(spacing: 12) {
                                Image("google-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Google")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("urbanist-SemiBold", size: 16))
                                    .frame(height: 60)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Dark4"), lineWidth: 1)
                            }
                        }
                        Button {
                            print("Get started")
                        } label: {
                            Text("Get Started")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("urbanist-SemiBold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
                                .background(Color("MyPrimary"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                        Button {
                            print("login")
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
    }
}

#Preview {
    WelcomeView()
}
