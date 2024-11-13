//
//  CookpediaApp.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI
import SwiftData

@main
struct CookpediaApp: App {
    
    @StateObject private var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) private var context: ModelContext
    @State private var isSessionAvailable: Bool? = nil
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let isSessionAvailable = isSessionAvailable {
                    if isSessionAvailable {
                        TabView()
                    } else {
                        WelcomeView()
                    }
                } else {
                    ProgressView("Checking session...") // Loading indicator
                        .onAppear(perform: checkUserSession)
                }
            }
            .environmentObject(apiPostManager)
        }
        .modelContainer(for: UserSession.self)
    }
    
    // Function to check if a user session is saved and log it
        private func checkUserSession() {
            let sessionDescriptor = FetchDescriptor<UserSession>(
                predicate: #Predicate { $0.isRemembered == true }
            )
            
            do {
                let sessions = try context.fetch(sessionDescriptor)
                if let session = sessions.first {
                    print("Persisted User ID: \(session.userId)")
                    print("Persisted Auth Token: \(session.authToken)")
                    isSessionAvailable = true
                } else {
                    print("No remembered session found.")
                    isSessionAvailable = false
                }
            } catch {
                print("Failed to fetch user session: \(error)")
                isSessionAvailable = false
            }
        }
}
