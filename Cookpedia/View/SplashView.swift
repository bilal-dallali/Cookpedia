//
//  SplashView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 14/11/2024.
//

import SwiftUI
import SwiftData
import FirebasePerformance

struct SplashView: View {
    
    @State private var isRotating: Bool = false
    @State private var redirectHomePage: Bool = false
    @State private var redirectWelcomePage: Bool = false
    let sessionDescriptor = FetchDescriptor<UserSession>(predicate: #Predicate { $0.isRemembered == true })
    @Environment(\.modelContext) private var context
    @Query(sort: \UserSession.userId) var userSession: [UserSession]
    @Query(sort: \UserSession.authToken) var userSessionToken: [UserSession]
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack(spacing: 184) {
            Spacer()
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .frame(width: 200, height: 200)
                Text("Cookpedia")
                    .foregroundStyle(Color("MyWhite"))
                    .font(.custom("Urbanist-Bold", size: 48))
            }
            Image("loader")
                .resizable()
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        isRotating = true
                    }
                }
        }
        .ignoresSafeArea(.all)
        .padding(.bottom, 108)
        .frame(maxWidth: .infinity)
        .background(Color("Dark1"))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let _ = try? context.fetch(sessionDescriptor).first {
                    redirectHomePage = true
                    if let session = userSession.first {
                        Task {
                            do {
                                let userId = try await apiGetManager.checkUserSession(token: session.authToken)
                                if userId != nil {
                                    redirectHomePage = true
                                } else {
                                    redirectWelcomePage = true
                                }
                            } catch {
                                redirectWelcomePage = true
                            }
                        }
                    } else {
                        redirectWelcomePage = true
                    }
                } else {
                    redirectWelcomePage = true
                }
            }
        }
        .navigationDestination(isPresented: $redirectHomePage) {
            TabView()
        }
        .navigationDestination(isPresented: $redirectWelcomePage) {
            WelcomeView()
        }
    }
}

#Preview {
    SplashView()
}
