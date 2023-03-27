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
                                Image("google-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Google")
                                    .foregroundColor(Color("Greyscale900"))
                                    .font(.custom("Urbanist-SemiBold", size: 16))
                                    .frame(height: 60)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color("White"))
                            .cornerRadius(.infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Greyscale200"), lineWidth: 1)
                                    .cornerRadius(.infinity)
                            }
                            
                        }
                        NavigationLink(destination: CountryView()) {
                            Text("Get Started")
                                .foregroundColor(Color("White"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary"))
                                .cornerRadius(.infinity)
                        }
                        NavigationLink(destination: LoginView()) {
                            Text("I Already Have an Account")
                                .foregroundColor(Color("Primary"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
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
