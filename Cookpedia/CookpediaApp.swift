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
    
    @StateObject private var apiManager = APIRequest()
    @Environment(\.modelContext) private var context: ModelContext
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Define a FetchDescriptor for UserSession
                let sessionDescriptor = FetchDescriptor<UserSession>(
                    predicate: #Predicate { $0.isRemembered == true }
                )
                
                // Perform the fetch
                if let session = try? context.fetch(sessionDescriptor).first {
                    TabView()
                } else {
                    WelcomeView()
                }
            }
            .environmentObject(apiManager)
        }
    }
}
