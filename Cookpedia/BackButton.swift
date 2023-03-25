//
//  BackButton.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2023.
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow-left")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(Color("Greyscale900"))
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
            .previewLayout(.sizeThatFits)
    }
}
