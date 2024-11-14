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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
            }
            .environmentObject(apiPostManager)
        }
        .modelContainer(for: UserSession.self)
    }
    
    
}

//import SwiftUI
//import SwiftData
//
//@main
//struct CookpediaApp: App {
//    
//    @StateObject private var apiPostManager = APIPostRequest()
//    @Environment(\.modelContext) private var context: ModelContext
//    //    @State private var isSessionAvailable: Bool? = nil
//    
//    // Propriété calculée pour vérifier la session isRemembered
//    private var isSessionAvailable: Bool {
//        let sessionDescriptor = FetchDescriptor<UserSession>(predicate: #Predicate { $0.isRemembered == true })
//        // Tente de récupérer une session avec isRemembered = true
//        if let _ = try? context.fetch(sessionDescriptor).first {
//            print("Session avec 'Se souvenir de moi' trouvée.")
//            return true
//        } else {
//            print("Aucune session avec 'Se souvenir de moi' trouvée.")
//            return false
//        }
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            if isSessionAvailable {
//                TabView()
//            } else {
//                WelcomeView()
//            }
//        }
//        .environmentObject(apiPostManager)
//    }
//}
