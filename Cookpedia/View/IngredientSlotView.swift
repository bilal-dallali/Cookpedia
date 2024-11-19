//
//  IngredientSlotView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 19/11/2024.
//

import SwiftUI

struct IngredientSlotView: View {
    
    @Binding var ingredient: String
    var index: Int
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image("drag-drop")
            Circle()
                .foregroundStyle(Color("Dark3"))
                .frame(width: 32, height: 32)
                .overlay {
                    Text("\(index + 1)")
                        .foregroundStyle(Color("Primary900"))
                        .font(.custom("Urbanist-Semibold", size: 16))
                }
            TextField("", text: $ingredient)
                .placeholder(when: ingredient.isEmpty) {
                    Text("Ingredients \(index + 1)")
                        .foregroundStyle(Color("Greyscale500"))
                        .font(.custom("Urbanist-Regular", size: 16))
                }
                .foregroundStyle(Color("MyWhite"))
                .font(.custom("Urbanist-Semibold", size: 16))
                .padding(.leading, 20)
                .frame(height: 58)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("Dark2"))
                }
            Button {
                withAnimation {
                    onDelete()
                }
            } label: {
                Image("delete")
            }

        }
    }
}

#Preview {
    IngredientSlotView(ingredient: .constant(""), index: 1, onDelete: {})
}
