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
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //
                } label: {
                    Image("Search - Regular - Light - Outline")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color("MyWhite"))
                }
            }
        }
        .onAppear {
            apiGetManager.getUsersByRecipeViews { result in
                switch result {
                    case .success(let users):
                    DispatchQueue.main.async {
                        self.mostPopularUsers = users
                    }
                    case .failure(let failure):
                        print("failure \(failure)")
                }
            }
        }
    }
}

#Preview {
    TopChefView()
}
