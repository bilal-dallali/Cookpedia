//
//  ForgotPasswordCheckEmailView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 04/11/2024.
//

import SwiftUI

struct ForgotPasswordCheckEmailView: View {
    
    @Binding var email: String
    @State private var code: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?
    @State private var isLoading: Bool = false
    @State private var isVerified: Bool = false
    @State private var errorMessage: String?
    var apiManager = APIRequest()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
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
                    HStack(spacing: 16) {
                        ForEach(0..<4, id: \.self) { index in
                            TextField("", text: $code[index])
                                .frame(height: 70)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .foregroundStyle(Color("MyWhite"))
                                .font(.custom("Urbanist-Bold", size: 20))
                                .focused($focusedIndex, equals: index)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color("Dark2"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(Color(index == focusedIndex ? "Primary900" : "Dark4"), lineWidth: 1)
                                        )
                                )
                                .onChange(of: code[index]) { newValue in
                                    if newValue.count > 1 {
                                        code[index] = String(newValue.prefix(1))
                                    } else if !newValue.isEmpty && index < 3 {
                                        focusedIndex = index + 1
                                    }
                                }
                        }
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
                Button(action: confirmCode) {
                    Text("Confirm")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color(code.joined().count == 4 ? "Primary900" : "DisabledButton"))
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                }
                .disabled(code.joined().count != 4)
                .alert(errorMessage ?? "Invalid Code", isPresented: Binding<Bool>(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )) {
                    Button("OK", role: .cancel) { }
                }
                
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .frame(height: 84)
            .frame(maxWidth: .infinity)
            .background(Color("Dark1"))
        }
        .navigationDestination(isPresented: $isVerified) {
            CreateNewPasswordView(email: $email)
        }
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
        
        .onAppear {
            focusedIndex = 0
        }
    }
    
    private func confirmCode() {
        guard code.joined().count == 4 else { return }
        
        isLoading = true
        apiManager.verifyResetCode(email: email, code: code.joined()) { result in
            isLoading = false
            switch result {
            case .success:
                print("OTP Verified!")
                isVerified = true
                // Handle successful verification, e.g., navigate to reset password screen
            case .failure(let error):
                errorMessage = error.localizedDescription
                print("OTP not verified!")
            }
        }
    }
}


#Preview {
    ForgotPasswordCheckEmailView(email: .constant(""))
}
