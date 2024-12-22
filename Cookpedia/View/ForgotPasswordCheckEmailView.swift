//
//  ForgotPasswordCheckEmailView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 04/11/2024.
//

import SwiftUI

struct ForgotPasswordCheckEmailView: View {
    
    @Binding var email: String
    @State var code: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?
    @FocusState private var isTextFocused: Bool
    @State private var isVerified: Bool = false
    @State private var errorMessage: String?
    
    @State private var timeRemaining = 30
    @State private var timerActive = false
    @State private var timer: Timer?
    
    var apiPostManager = APIPostRequest()
    
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
                                .focused($isTextFocused)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color("Dark2"))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(Color(index == focusedIndex ? "Primary900" : "Dark4"), lineWidth: 1)
                                        }
                                }
                                .onChange(of: code[index]) {
                                    if code[index].count > 1 {
                                        code[index] = String(code[index].prefix(1))
                                    } else if !code[index].isEmpty && index < 3 {
                                        focusedIndex = index + 1
                                    }
                                }
                                
                        }
                    }
                    VStack(spacing: 16) {
                        Text("Didn't receive email?")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Medium", size: 18))
                        if timerActive {
                            HStack(spacing: 0) {
                                Text("You can resend code in ")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Medium", size: 18))
                                Text("\(timeRemaining)")
                                    .foregroundStyle(Color("Primary900"))
                                    .font(.custom("Urbanist-Medium", size: 18))
                                Text(" s")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Medium", size: 18))
                            }
                        } else {
                            HStack(spacing: 8) {
                                Text("You can resend code in")
                                    .foregroundStyle(Color("MyWhite"))
                                    .font(.custom("Urbanist-Medium", size: 18))
                                Button {
                                    timerActive = true
                                    timeRemaining = 60
                                    apiPostManager.sendResetCode(email: email) { result in
                                        
                                    }
                                } label: {
                                    Text("Resend")
                                        .foregroundStyle(Color("MyWhite"))
                                        .font(.custom("Urbanist-SemiBold", size: 16))
                                        .frame(width: 86, height: 38)
                                        .background(Color("Primary900"))
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            VStack(spacing: 0) {
                Divider()
                    .overlay {
                        Rectangle()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color("Dark4"))
                    }
                if code.joined().count == 4 {
                    Button {
                        apiPostManager.verifyResetCode(email: email, code: code.joined()) { result in
                            switch result {
                            case .success:
                                isVerified = true
                                // Handle successful verification, e.g., navigate to reset password screen
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Confirm")
                            .foregroundStyle(Color("MyWhite"))
                            .font(.custom("Urbanist-Bold", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("Primary900"))
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .shadow(color: Color(red: 0.96, green: 0.28, blue: 0.29).opacity(0.25), radius: 12, x: 4, y: 8)
                            .padding(.horizontal, 24)
                            .padding(.top, 24)
                            .padding(.bottom, 36)
                    }

                } else {
                    Text("Confirm")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color("DisabledButton"))
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 36)
                }
            }
        }
        .navigationDestination(isPresented: $isVerified) {
            CreateNewPasswordView(email: $email, code: $code)
        }
        .background(Color("Dark1"))
        .ignoresSafeArea(edges: isTextFocused == false ? .bottom : [])
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .onAppear {
            focusedIndex = 0
            timerActive = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timerActive = false
                }
            }
        }
        .alert("Invalid Code", isPresented: Binding<Bool>(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        }
    }
}


#Preview {
    ForgotPasswordCheckEmailView(email: .constant(""))
}
