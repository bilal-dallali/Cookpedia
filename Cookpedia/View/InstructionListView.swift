//
//  InstructionListView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 23/11/2024.
//

import SwiftUI
import Foundation

struct InstructionListView: View {
    
    @Binding var instructions: [CreateRecipeView.Instruction]
    @Binding var instructionCounter: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(instructions.indices, id: \.self) { index in
                InstructionSlotView(
                    instruction: $instructions[index].text,
                    images: $instructions[index].images,
                    instructionPictureUrl1: $instructions[index].instructionPictureUrl1,
                    instructionPictureUrl2: $instructions[index].instructionPictureUrl2,
                    instructionPictureUrl3: $instructions[index].instructionPictureUrl3,
                    onDelete: {
                        instructions.remove(at: index)
                    },
                    number: index + 1
                )
            }
            Button {
                withAnimation {
                    instructions.append(CreateRecipeView.Instruction())
                }
            } label: {
                HStack {
                    Image("Icon=plus, Component=Additional Icons")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color("MyWhite"))
                    Text("Add Instructions")
                        .foregroundStyle(Color("MyWhite"))
                        .font(.custom("Urbanist-Bold", size: 16))
                }
                .frame(height: 58)
                .frame(maxWidth: .infinity)
                .background(Color("Dark4"))
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
            }
        }
    }
}

#Preview {
    @Previewable @State var sampleInstructions: [CreateRecipeView.Instruction] = [
        CreateRecipeView.Instruction(text: "Mix the ingredients.", images: [UIImage(systemName: "photo")!]),
        CreateRecipeView.Instruction(text: "Bake at 180°C.", images: []),
        CreateRecipeView.Instruction(text: "Let it cool before serving.", images: [])
    ]
    InstructionListView(instructions: $sampleInstructions, instructionCounter: .constant(1))
}
