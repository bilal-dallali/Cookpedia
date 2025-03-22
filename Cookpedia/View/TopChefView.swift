//
//  TopChefView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2025.
//

import SwiftUI

struct TopChefView: View {
    
    @State private var mostPopularUsers: [UserDetails] = []
    var apiGetManager = APIGetRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 0)], spacing: 16) {
                    ForEach(mostPopularUsers, id: \.id) { user in
                        NavigationLink {
                            ProfilePageView(userId: user.id)
                        } label: {
                            TopChefSmallCardView(user: user)
                                .frame(height: 260)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 24)
        .ignoresSafeArea(edges: .bottom)
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Top Chefs")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 24))
                        .padding(.leading, 16)
                    Spacer()
                }
            }
        }
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "view_top_chef_page")
            
            Task {
                do {
                    let users = try await apiGetManager.getUsersByRecipeViews()
                    DispatchQueue.main.async {
                        self.mostPopularUsers = users
                    }
                } catch {
                    print("Failed to load users by recipe views")
                }
            }
        }
    }
}

#Preview {
    TopChefView()
}
