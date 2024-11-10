//
//  ModalView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 29/10/2024.
//

import SwiftUI

struct SignUpSuccessfulView: View {
    
    @State private var isRotating: Bool = false
    
    @State var title: String
    @State var message: String
    
    var body: some View {
        VStack(spacing: 32) {
            Image("modal-icon")
            Text(title)
                .foregroundStyle(Color("Primary900"))
                .font(.custom("Urbanist-Bold", size: 24))
            Text(message)
                .foregroundStyle(Color("MyWhite"))
                .font(.custom("Urbanist-Regular", size: 16))
                .frame(width: 276)
                .multilineTextAlignment(.center)
            Image("modal-loader")
                .resizable()
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        isRotating = true
                    }
                }
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
        .padding(.horizontal, 32)
        .background(Color("Dark2"))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        
    }
}

#Preview {
    SignUpSuccessfulView(title: "Sign Up Successful", message: "Your account has been created. Please wait a moment, we are preparing for you...")
}
