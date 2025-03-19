//
//  SettingsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 05/01/2025.
//

import SwiftUI
import SwiftData
import FirebaseCrashlytics

struct SettingsView: View {
    
    @State private var redirectWelcomePage = false
    @State private var doLogout = false
    @Environment(\.modelContext) private var context
    @Query(sort: \UserSession.userId) private var userSessions: [UserSession]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button {
                        doLogout = true
                    } label: {
                        HStack(spacing: 20) {
                            Circle()
                                .frame(width: 56, height: 56)
                                .foregroundStyle(Color("TransparentRed"))
                                .overlay {
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.96, green: 0.28, blue: 0.29), location: 0.00),
                                            Gradient.Stop(color: Color(red: 1, green: 0.45, blue: 0.46), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 1, y: 1),
                                        endPoint: UnitPoint(x: 0, y: 0)
                                    )
                                    .frame(width: 24, height: 24)
                                    .mask {
                                        Image("Logout - Regular - Bold")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                }
                            Text("Logout")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                            Spacer()
                            Image("Arrow - Right 2 - Regular - Light - Outline")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color("MyWhite"))
                        }
                    }
                    
                }
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Settings")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $doLogout) {
            VStack(spacing: 24) {
                Text("Delete Recipe")
                    .foregroundStyle(Color("Error"))
                    .font(.custom("Urbanist-Bold", size: 24))
                Divider()
                    .overlay {
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundStyle(Color("Dark4"))
                            .frame(height: 1)
                    }
                Text("Are you sure you want to log out ?")
                    .foregroundStyle(Color("MyWhite"))
                    .font(.custom("Urbanist-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .frame(height: 64)
                HStack(spacing: 12) {
                    Button {
                        doLogout = false
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Dark4"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    }
                    
                    Button {
                        guard let currentSession = userSessions.first else {
                            return
                        }
                        
                        // Delete the session from context
                        context.delete(currentSession)
                        
                        do {
                            try context.save()
                        } catch {
                            print("Erreur lors de la suppression de la session utilisateur : \(error.localizedDescription)")
                        }
                        doLogout = false
                        redirectWelcomePage = true
                        
                        Crashlytics.crashlytics().log("User logged out")
                        AnalyticsManager.shared.logEvent(name: "logout")
                    } label: {
                        Text("Yes, Logout")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .clipShape(RoundedRectangle(cornerRadius: 44))
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(260)])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Dark2"))
        }
        .navigationDestination(isPresented: $redirectWelcomePage) {
            WelcomeView()
        }
    }
}

#Preview {
    SettingsView()
}
