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
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
            }
        }
        .modelContainer(for: UserSession.self)
    }
}
