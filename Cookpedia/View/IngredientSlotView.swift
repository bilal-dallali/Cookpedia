//
//  IngredientSlotView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 19/11/2024.
//

import SwiftUI

struct IngredientSlotView: View {
    
    @FocusState private var isIngredientFocused: Bool
    @Binding var ingredient: String
    let index: Int
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image("Icon=drag-drop, Component=Additional Icons")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color("MyWhite"))
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
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(minHeight: 58)
            .background(Color("Dark2"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .focused($isIngredientFocused)
            .submitLabel(.next)
            Button {
                withAnimation {
                    onDelete()
                }
            } label: {
                Image("Delete - Regular - Light - Outline")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color("Error"))
            }
        }
        .onTapGesture {
            isIngredientFocused = false
        }
    }
}

#Preview {
    IngredientSlotView(ingredient: .constant(""), index: 1, onDelete: {})
}
