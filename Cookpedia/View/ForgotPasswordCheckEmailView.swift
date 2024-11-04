//
//  ForgotPasswordCheckEmailView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 04/11/2024.
//

import SwiftUI

struct ForgotPasswordCheckEmailView: View {
    
    @Binding var email: String
    
    @FocusState private var isCaseOneFocused: Bool
    
    @State private var caseOne: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You’ve Got Mail 📩")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 32))
                        Text("We have sent the OTP verification code to your email address. Check your email and enter the code below.")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Regular", size: 18))
                    }
                    Spacer()
                    VStack(spacing: 40) {
                        TextField("", text: $caseOne)
                            .frame(height: 70)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 20))
                            .focused($isCaseOneFocused)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("Dark2"))
                                    .strokeBorder(Color(isCaseOneFocused ? "Primary900" : "Dark4"), lineWidth: 1)
                            }
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color("Dark4"))
                    }
                
                VStack {
                    Text("Confirm")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("Primary900"))
                        .clipShape(.rect(cornerRadius: .infinity))
                        .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .frame(height: 84)
                .frame(maxWidth: .infinity)
                .background(Color("Dark1"))
            }
            .background(Color("Dark1"))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView()
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordCheckEmailView(email: .constant(""))
}
