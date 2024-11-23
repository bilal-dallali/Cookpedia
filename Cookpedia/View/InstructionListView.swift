//
//  InstructionListView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 23/11/2024.
//

import SwiftUI

struct InstructionListView: View {
    
    @Binding var instructions: [CreateRecipeView.Instruction]
    @Binding var instructionCounter: Int
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(instructions.indices, id: \.self) { index in
                    InstructionSlotView(
                        instruction: $instructions[index].text,
                        images: $instructions[index].images,
                        onDelete: {
                            instructions.remove(at: index)
                        },
                        number: index + 1
                    )
                }
                
                Button {
                    instructionCounter += 1
                    instructions.append(CreateRecipeView.Instruction(number: instructionCounter))
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 15, height: 15)
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
}

#Preview {
    @Previewable @State var sampleInstructions: [CreateRecipeView.Instruction] = [
        CreateRecipeView.Instruction(text: "Mix the ingredients.", images: [UIImage(systemName: "photo")!], number: 0),
        CreateRecipeView.Instruction(text: "Bake at 180°C.", images: [], number: 0),
        CreateRecipeView.Instruction(text: "Let it cool before serving.", images: [], number: 0)
    ]
    InstructionListView(instructions: $sampleInstructions, instructionCounter: .constant(1))
}
