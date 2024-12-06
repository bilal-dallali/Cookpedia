//
//  MyRecipePageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 30/10/2024.
//

import SwiftUI

struct MyRecipePageView: View {
    
    @State private var isDraftSelected: Bool = true
    @State private var isPublishedSelected: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Image("logo")
                                .resizable()
                                .frame(width: 28, height: 28)
                            Text("My Recipes")
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 24))
                        }
                        Spacer()
                        HStack(spacing: 20) {
                            Button {
                                //
                            } label: {
                                Image("search-icon")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                            
                            Button {
                                //
                            } label: {
                                Image("more-circle")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 28) {
                        HStack(spacing: 0) {
                            Button {
                                isDraftSelected = true
                                isPublishedSelected = false
                            } label: {
                                VStack(spacing: 12) {
                                    if isDraftSelected {
                                        Text("Draft (24)")
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
                                        Text("Draft (24)")
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
                                isDraftSelected = false
                                isPublishedSelected = true
                            } label: {
                                VStack(spacing: 12) {
                                    if isPublishedSelected {
                                        Text("Published (125)")
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
                                        Text("Published (125)")
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
                        
                        if isDraftSelected {
                            Text("Draft")
                        } else if isPublishedSelected {
                            Text("Published")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 16)
            .padding(.horizontal, 24)
            .background(Color("Dark1"))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MyRecipePageView()
}
