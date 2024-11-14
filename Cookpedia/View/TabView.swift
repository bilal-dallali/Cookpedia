//
//  TabView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI
import SwiftData

struct TabView: View {
    
    @State private var isHomeSelected: Bool = true
    @State private var isDiscoverSelected: Bool = false
    @State private var isMyRecipeSelected: Bool = false
    @State private var isMyProfileSelected: Bool = false
    
    
    @StateObject private var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) private var context: ModelContext

    @State private var lastError: String? = nil // Pour stocker les erreurs
    
    var body: some View {
        ZStack {
            if isHomeSelected {
                HomePageView()
            } else if isDiscoverSelected {
                DiscoverPageView()
            } else if isMyRecipeSelected {
                MyRecipePageView()
            } else if isMyProfileSelected {
                MyProfilePageView()
            }
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 19) {
                        Button {
                            isHomeSelected = true
                            isDiscoverSelected = false
                            isMyRecipeSelected = false
                            isMyProfileSelected = false
                        } label: {
                            VStack(spacing: 2) {
                                Image(isHomeSelected ? "house-selected" : "house")
                                Text("Home")
                                    .foregroundStyle(Color(isHomeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isHomeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            isHomeSelected = false
                            isDiscoverSelected = true
                            isMyRecipeSelected = false
                            isMyProfileSelected = false
                        } label: {
                            VStack(spacing: 2) {
                                Image(isDiscoverSelected ? "discover-selected" : "discover")
                                Text("Discover")
                                    .foregroundStyle(Color(isDiscoverSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isDiscoverSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            checkAndSendUserSession()
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color("Primary900"))
                                    .frame(width: 38, height: 38)
                                    .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29, opacity: 0.25), radius: 12, x: 4, y: 8)
                                Image(systemName: "plus")
                                    .foregroundColor(Color("MyWhite"))
                                    .frame(width: 12, height: 12)
                            }
                            
                        }
                        
                        Button {
                            isHomeSelected = false
                            isDiscoverSelected = false
                            isMyRecipeSelected = true
                            isMyProfileSelected = false
                        } label: {
                            VStack(spacing: 2) {
                                Image(isMyRecipeSelected ? "recipe-selected" : "recipe")
                                Text("My Recipes")
                                    .foregroundStyle(Color(isMyRecipeSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isMyRecipeSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            isHomeSelected = false
                            isDiscoverSelected = false
                            isMyRecipeSelected = false
                            isMyProfileSelected = true
                        } label: {
                            VStack(spacing: 2) {
                                Image(isMyProfileSelected ? "profile-selected" : "profile")
                                Text("Profile")
                                    .foregroundStyle(Color(isMyProfileSelected ? "Primary900" : "Greyscale500"))
                                    .font(.custom(isMyProfileSelected ? "Urbanist-Bold" : "Urbanist-Medium", size: 10))
                            }
                        }
                        .frame(maxWidth: .infinity)

                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 5)
                    
                }
                .padding(.top, 8)
                .padding(.bottom, 29)
                .background {
                    Rectangle()
                        .fill(Color(red: 0.09, green: 0.1, blue: 0.13, opacity: 0.85))
                        
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private func checkAndSendUserSession() {
        let sessionDescriptor = FetchDescriptor<UserSession>(predicate: #Predicate { $0.isRemembered == true })
        print("session descriptor : \(sessionDescriptor)")
        do {
            let sessions = try context.fetch(sessionDescriptor)
            guard let activeSession = sessions.first else {
                print("Aucune session active trouvée sur le frontend.")
                // Appeler la requête backend sans session active
                sendSessionDataToBackend(userId: nil, authToken: nil, isRemembered: false)
                return
            }
            
            print("Session active trouvée : ID utilisateur :", activeSession.userId)
            // Envoyer l'ID utilisateur et le token au backend
            sendSessionDataToBackend(userId: activeSession.userId, authToken: activeSession.authToken, isRemembered: activeSession.isRemembered)
            
        } catch {
            print("Erreur lors de la vérification de la session dans SwiftData :", error.localizedDescription)
        }
    }
    
    private func sendSessionDataToBackend(userId: String?, authToken: String?, isRemembered: Bool) {
        let baseUrl = "http://localhost:3000/api"
        let endpoint = "/verify-session"
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            print("URL invalide pour la vérification de session.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": userId ?? "",
            "authToken": authToken ?? "",
            "isRemembered": isRemembered
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Erreur réseau :", error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Réponse invalide reçue.")
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    print("Session valide vérifiée sur le backend.")
                case 404:
                    print("Aucune session active trouvée sur le backend.")
                default:
                    print("Erreur serveur avec code :", httpResponse.statusCode)
                }
            }.resume()
        } catch {
            print("Erreur lors de l'encodage JSON :", error.localizedDescription)
        }
    }
    
}

#Preview {
    TabView()
}
