//
//  ForgottenPassword.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 07/03/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email = ""
    @FocusState private var emailFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            Text("forgotten password")
        }

    }
}

struct ForgottenPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
