//
//  ContentView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 06/03/2023.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 32) {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            Text("Welcome to ")
                                .font(.custom("Urbanist-Bold", size: 40))
                                .foregroundColor(Color("White"))
                            Text("Cookpedia 👋 ")
                                .font(.custom("Urbanist-Bold", size: 40))
                                .foregroundColor(Color("Primary"))
                        }
                        Text("The best cooking and food recipes app of the century.")
                            .foregroundColor(Color("White"))
                            .multilineTextAlignment(.center)
                            .font(.custom("Urbanist-Medium", size: 20))
                            .lineSpacing(10)
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color("Dark4"))
                        }
                    VStack(spacing: 24) {
                        Button {
                            print("continue with google")
                        } label: {
                            HStack(spacing: 12) {
                                Spacer()
                                Image("google-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Google")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-SemiBold", size: 16))
                                    .frame(height: 60)
                                Spacer()
                            }
                            .background(Color("White"))
                            .cornerRadius(.infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Greyscale200"), lineWidth: 1)
                                    .cornerRadius(.infinity)
                            }
                        }
                        NavigationLink {
                            CountryView()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Get Started")
                                    .foregroundColor(Color("White"))
                                    .frame(height: 58)
                                    .font(.custom("Urbanist-Bold", size: 16))
                                Spacer()
                            }
                            .background(Color("Primary"))
                            .cornerRadius(.infinity)
                        }
                        NavigationLink {
                            LoginView()
                        } label: {
                            HStack {
                                Spacer()
                                Text("I Already Have an Account")
                                    .foregroundColor(Color("Primary"))
                                    .frame(height: 58)
                                    .font(.custom("Urbanist-Bold", size: 16))
                                Spacer()
                            }
                            .background(Color("Primary50"))
                            .cornerRadius(.infinity)
                        }
                    }
                }
                .padding(.horizontal, 48)
                .padding(.top, 13)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
