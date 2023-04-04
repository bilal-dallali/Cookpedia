//
//  ModalView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 04/04/2023.
//

import SwiftUI

struct ModalView: View {
    
    @State private var isRotating = false
    
    var body: some View {
        VStack(spacing: 32) {
            Image("modal-icon")
            VStack(spacing: 16) {
                Text("Sign Up Successful!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Primary"))
                    .font(.custom("Urbanist-Bold", size: 24))
                Text("Your account has been created. Please wait a moment, we are preparing for you...")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("Greyscale900"))
                    .font(.custom("Urbanist-Regular", size: 16))
            }
            Image("modal-loader")
                .rotationEffect(isRotating ? .degrees(360) : .degrees(0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isRotating = true
                }
        }
        
        .padding(.top, 40)
        .padding(.bottom, 32)
        .padding(.horizontal, 32)
        .frame(width: 340)
        .background(Color("White"))
        .cornerRadius(40)
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
            .previewLayout(.sizeThatFits)
            .background(.gray)
            .padding()
            .background(.gray)
    }
}
