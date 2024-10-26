//
//  BackButtonView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 25/10/2024.
//

import SwiftUI

struct BackButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow-left")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundStyle(Color("MyWhite"))
        }

    }
}

#Preview {
    BackButtonView()
}
