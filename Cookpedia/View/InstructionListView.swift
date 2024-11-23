//
//  InstructionListView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 23/11/2024.
//

import SwiftUI

struct InstructionListView: View {
    
    @Binding var instructions: [CreateRecipeView.Instruction]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(instructions.enumerated()), id: \.element.id) { index, instruction in
                    InstructionSlotView(
                        instruction: $instructions[index].text,
                        images: $instructions[index].images,
                        onDelete: { _ in
                            instructions.remove(at: index)
                        },
                        index: index // Passez l'index correctement ici
                    )
                }
                
                Button {
                    instructions.append(CreateRecipeView.Instruction())
                } label: {
                    Text("add instruction")
                }
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
    
    InstructionListView(instructions: $sampleInstructions)
}
