//
//  IngredientSlotView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 19/11/2024.
//

import SwiftUI

struct IngredientSlotView: View {
    
    @Binding var ingredient: String
    let index: Int
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image("drag-drop")
                .resizable()
                .frame(width: 24, height: 24)
            Circle()
                .foregroundStyle(Color("Dark3"))
                .frame(width: 32, height: 32)
                .overlay {
                    Text("\(index + 1)")
                        .foregroundStyle(Color("Primary900"))
                        .font(.custom("Urbanist-Semibold", size: 16))
                }
            TextField(text: $ingredient) {
                Text("Ingredients \(index + 1)")
                    .foregroundStyle(Color("Greyscale500"))
                    .font(.custom("Urbanist-Regular", size: 16))
                    
            }
            .keyboardType(.default)
            .foregroundStyle(Color("MyWhite"))
            .font(.custom("Urbanist-Semibold", size: 16))
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(minHeight: 58)
            .background(Color("Dark2"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Button {
                onDelete()
            } label: {
                Image("delete")
            }
            
        }
    }
}

#Preview {
    IngredientSlotView(ingredient: .constant(""), index: 1, onDelete: {})
}
