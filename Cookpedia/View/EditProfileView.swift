//
//  EditProfileView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 15/12/2024.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Hello, World!")
                }
            }
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

#Preview {
    EditProfileView()
}
