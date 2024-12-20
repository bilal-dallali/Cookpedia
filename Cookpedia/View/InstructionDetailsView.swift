//
//  InstructionDetailsView.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 20/12/2024.
//

import SwiftUI

struct InstructionDetailsView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .foregroundStyle(Color("Dark3"))
                .frame(width: 32, height: 32)
                .overlay {
                    Text("1")
                        .foregroundStyle(Color("Primary900"))
                        .font(.custom("Urbanist-Semibold", size: 16))
                }
//            VStack(spacing: 12) {
//                Text("")
//                    .foregroundStyle(Color("MyWhite"))
//                    .font(.custom("Urbanist-Medium", size: 18))
//                HStack(spacing: 8) {
//                    AsyncImage(url: URL(string: "\(baseUrl)/recipes/instruction-image/.jpg")) { image in
//                        image
//                            .resizable()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 80)
//                    } placeholder: {
//                        RoundedRectangle(cornerRadius: 12)
//                            .resizable()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 80)
//                    }
//                }
//            }
        }
    }
}

#Preview {
    InstructionDetailsView()
}
