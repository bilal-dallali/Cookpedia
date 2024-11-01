//
//  NotificationPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 31/10/2024.
//

import SwiftUI

struct NotificationPageView: View {
    
    @State private var isGeneralSelected: Bool = true
    @State private var isSystemSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 0) {
                Button {
                    isGeneralSelected = true
                    isSystemSelected = false
                } label: {
                    VStack(spacing: 12) {
                        if isGeneralSelected {
                            Text("General")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-SemiBold", size: 18))
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .fill(Color("Primary900"))
                                        .frame(height: 4)
                                        .clipShape(.rect(cornerRadius: 100))
                                }
                        } else {
                            Text("General")
                                .foregroundStyle(Color("Greyscale700"))
                                .font(.custom("Urbanist-SemiBold", size: 18))
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .fill(Color("Dark4"))
                                        .frame(height: 2)
                                        .clipShape(.rect(cornerRadius: 100))
                                }
                        }
                    }
                }
                
                Button {
                    isGeneralSelected = false
                    isSystemSelected = true
                } label: {
                    VStack(spacing: 12) {
                        if isSystemSelected {
                            Text("System")
                                .foregroundStyle(Color("Primary900"))
                                .font(.custom("Urbanist-SemiBold", size: 18))
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .fill(Color("Primary900"))
                                        .frame(height: 4)
                                        .clipShape(.rect(cornerRadius: 100))
                                }
                        } else {
                            Text("System")
                                .foregroundStyle(Color("Greyscale700"))
                                .font(.custom("Urbanist-SemiBold", size: 18))
                            Divider()
                                .overlay {
                                    Rectangle()
                                        .fill(Color("Dark4"))
                                        .frame(height: 2)
                                        .clipShape(.rect(cornerRadius: 100))
                                }
                        }
                    }
                }
                
            }
            .frame(height: 41)
            .frame(maxWidth: .infinity)
            ScrollView {
                VStack(spacing: 60) {
                    Image("empty")
                        .resizable()
                        .frame(width: 280, height: 273)
                    VStack(spacing: 12) {
                        Text("Empty")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 24))
                        Text("You don't have any notification at this time")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                }
                .padding(.vertical, 140)
            }
            
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
                    Text("Notification")
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
                    Image("setting")
                        .resizable()
                        .frame(width: 28, height: 28)
                }

            }
        }
    }
}

#Preview {
    NotificationPageView()
}
