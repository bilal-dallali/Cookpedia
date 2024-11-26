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
    
    //@StateObject private var apiPostManager = APIPostRequest()
    //@Environment(\.modelContext) private var context: ModelContext
    
    let container: ModelContainer = {
        let schema = Schema([UserSession.self])
        let config = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
                    .modelContainer(for: [UserSession.self])
            }
            //.environmentObject(apiPostManager)
        }
        //.modelContainer(container)
        .modelContainer(for: [UserSession.self])
    }
}
