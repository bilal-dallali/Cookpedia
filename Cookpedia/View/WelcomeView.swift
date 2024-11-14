//
//  WelcomeView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    
    @StateObject private var apiPostManager = APIPostRequest()
    @Environment(\.modelContext) private var context: ModelContext

    @State private var lastError: String? = nil // Pour stocker les erreurs
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(spacing: 32) {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            Text("Welcome to ")
                                .font(.custom("Urbanist-Bold", size: 40))
                                .foregroundStyle(Color("MyWhite"))
                            Text("Cookpedia 👋 ")
                                .font(.custom("Urbanist-Bold", size: 40))
                                .foregroundStyle(Color("Primary900"))
                        }
                        Text("The best cooking and food recipes app of the century.")
                            .foregroundColor(Color("MyWhite"))
                            .multilineTextAlignment(.center)
                            .font(.custom("Urbanist-Medium", size: 20))
                            .lineSpacing(10)
                    }
                    Divider()
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color("Dark4"))
                        }
                    VStack(spacing: 24) {
                        Button {
                            checkAndSendUserSession()
                        } label: {
                            HStack(spacing: 12) {
                                Image("google-logo")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text("Continue with Google")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("urbanist-SemiBold", size: 16))
                                    .frame(height: 60)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color("Dark2"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .overlay {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(Color("Dark4"), lineWidth: 1)
                            }
                        }
                        NavigationLink {
                            CountryView()
                        } label: {
                            Text("Get Started")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("urbanist-SemiBold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
                                .background(Color("Primary900"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("I Already Have an Account")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 16))
                                .frame(height: 58)
                                .frame(maxWidth: .infinity)
                                .background(Color("Dark4"))
                                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        }


                    }
                }
                .padding(.horizontal, 48)
                .padding(.top, 13)
            }
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
    WelcomeView()
}
