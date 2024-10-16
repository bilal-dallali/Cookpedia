//
//  MyRecipeCardView.swift
//  Cookpedia
//
//  Created by Bilal D on 03/06/2024.
//

import SwiftUI

struct MyRecipeCardView: View {
    
    var title: String
    var image: String
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 183, height: 260)
            LinearGradient(gradient: Gradient(colors: [Color(red: 34/255, green: 34/255, blue: 34/255, opacity: 0), Color(red: 33/255, green: 33/255, blue: 33/255, opacity: 0.5), Color(red: 21/255, green: 21/255, blue: 21/255, opacity: 0.8), Color(red: 23/255, green: 23/255, blue: 23/255, opacity: 1), Color(red: 26/255, green: 26/255, blue: 26/255, opacity: 1)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 140)
                .offset(y: 70)
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action: {
                        // edit recipe
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 36, height: 36)
                                .foregroundColor(Color("Primary"))
                                .shadow(color: Color(red: 245/255, green: 72/255, blue: 74/255, opacity: 0.25), radius: 24, x: 4, y: 8)
                            Image("edit-white")
                        }
                        .padding(12)
                    })
                    
                }
                Spacer()
                Text(title)
                    .foregroundColor(Color("White"))
                    .font(.custom("Urbanist-Bold", size: 18))
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("Greyscale100"), lineWidth: 1)
        }
        .cornerRadius(20)
    }
}

#Preview {
    MyRecipeCardView(title: "Vegetable Fruit Salad Simple Rec...", image: "original-pizza")
        .previewLayout(.sizeThatFits)
        .frame(width: 183, height: 260)
        .padding()
}
