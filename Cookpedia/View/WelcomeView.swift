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
//        GeometryReader { geometry in
//            NavigationStack {
//                ZStack {
//                    ZStack(alignment: .top) {
//                        Image("main-background")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .ignoresSafeArea()
//                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
//                        LinearGradient(gradient: Gradient(stops: [
//                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0), location: 0.0),
//                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.8), location: 0.54),
//                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.95), location: 0.86),
//                                Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 1), location: 1.0)
//                        ]), startPoint: .bottom, endPoint: .top)
//                        .frame(height: 92)
//                        .ignoresSafeArea()
//                    }
//                    VStack(spacing: 32) {
//                        VStack(spacing: 15) {
//                            Text("Welcome to ")
//                                .foregroundStyle(Color("MyWhite"))
//                                .font(.custom("Urbanist-Bold", size: 48))
//                                .multilineTextAlignment(.center)
//                            Text("Cookpedia 👋 ")
//                                .foregroundStyle(Color("Primary900"))
//                                .font(.custom("Urbanist-Bold", size: 48))
//                                .multilineTextAlignment(.center)
//                        }
//                        Text("The best cooking and food recipes app of the century.")
//                            .foregroundStyle(Color("MyWhite"))
//                            .font(.custom("Urbanist-Medium", size: 20))
//                            .multilineTextAlignment(.center)
//                        Divider()
//                            .overlay {
//                                Rectangle()
//                                    .fill(Color("Dark4"))
//                            }
//                        NavigationLink {
//                            CountryView()
//                        } label: {
//                            Text("Get Started")
//                                .foregroundStyle(Color("MyWhite"))
//                                .font(.custom("Urbanist-Bold", size: 16))
//                                .frame(height: 58)
//                                .frame(maxWidth: .infinity)
//                                .background(Color("Primary900"))
//                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
//                        }
//                        
//                        NavigationLink {
//                            LoginView()
//                        } label: {
//                            Text("I Already Have an Account")
//                                .foregroundStyle(Color("MyWhite"))
//                                .font(.custom("Urbanist-Bold", size: 16))
//                                .frame(height: 58)
//                                .frame(maxWidth: .infinity)
//                                .background(Color("Dark4"))
//                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
//                        }
//                    }
//                    .padding(.horizontal, 48)
//                    .padding(.top, 62)
//                    .padding(.bottom, 36)
//                    .frame(width: geometry.size.width)
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//        }
        
        NavigationStack {
            VStack(spacing: 105) {
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0), location: 0),
                    .init(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.8), location: 0.54),
                    .init(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.95), location: 0.86),
                    .init(color: Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 1), location: 1)
                ]), startPoint: UnitPoint(x: 0.5, y: 1), endPoint: UnitPoint(x: 0.5, y: 0))
                .frame(height: 92)
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 32) {
                    VStack(spacing: 20) {
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
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("I Already Have an Account")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(maxWidth: .infinity)
                                .frame(height: 58)
                                .background(Color("Dark4"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                    }
                    
                }
                .padding(.horizontal, 48)
                .padding(.vertical, 32)
                Spacer()
            }
            .ignoresSafeArea()
            .padding(.horizontal, 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    WelcomeView()
}
