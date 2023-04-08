//
//  HomePage.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 08/04/2023.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        Text("You are on the home page")
            .font(.custom("Urbanist-Bold", size: 24))
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
