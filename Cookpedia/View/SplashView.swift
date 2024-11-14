//
//  SplashView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 14/11/2024.
//

import SwiftUI
import SwiftData

struct SplashView: View {
    
    @State private var redirectHomePage: Bool = false
    @State private var redirectWelcomePage: Bool = false
    let sessionDescriptor = FetchDescriptor<UserSession>(predicate: #Predicate { $0.isRemembered == true })
    
    @StateObject private var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) private var context: ModelContext
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        if let _ = try? context.fetch(sessionDescriptor).first {
                            print("Session trouvée - Redirection vers TabView")
                            redirectHomePage = true
                        } else {
                            print("Aucune session avec 'Se souvenir de moi' trouvée - Redirection vers WelcomeView")
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
}

#Preview {
    SplashView()
}
