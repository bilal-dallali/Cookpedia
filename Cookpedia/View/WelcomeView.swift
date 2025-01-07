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
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    ZStack(alignment: .top) {
                        Image("main-background")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        LinearGradient(
                            gradient: Gradient(stops: [
                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0), location: 0.0),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.8), location: 0.54),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.95), location: 0.86),
                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 1), location: 1.0)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 92)
                        .ignoresSafeArea()
                    }
                    VStack(spacing: 32) {
                        VStack(spacing: 15) {
                            Text("Welcome to ")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 48))
                                .multilineTextAlignment(.center)
                            Text("Cookpedia 👋 ")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-Bold", size: 48))
                                .multilineTextAlignment(.center)
                        }
                        Text("The best cooking and food recipes app of the century.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Medium", size: 20))
                            .multilineTextAlignment(.center)
                        Divider()
                            .overlay {
                                Rectangle()
                                    .fill(Color("Dark4"))
                            }
                        NavigationLink {
                            CountryView()
                        } label: {
                            Text("Get Started")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
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
                    .padding(.horizontal, 48)
                    .padding(.top, 62)
                    .padding(.bottom, 36)
                    .frame(width: geometry.size.width)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
