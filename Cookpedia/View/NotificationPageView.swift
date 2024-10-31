//
//  NotificationPageView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 31/10/2024.
//

import SwiftUI

struct NotificationPageView: View {
    var body: some View {
        VStack {
            Text("Notification")
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color("Dark1"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
            }
            ToolbarItem(placement: .principal) {
                Text("Notification")
            }
        }
    }
}

#Preview {
    NotificationPageView()
}
