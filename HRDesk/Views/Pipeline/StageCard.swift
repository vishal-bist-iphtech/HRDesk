//
//  StageCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI

struct StageCard: View {

    let stage: PipelineStage
    var count: Int = 0

    var body: some View {

        VStack(spacing: 6) {

            Image(systemName: stage.icon)
                .font(.title2.weight(.medium))
                .foregroundStyle(stage.color)

            Text(stage.title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color("textPrimary").opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text("\(count)")
                .font(.headline.weight(.medium))
                .foregroundStyle(Color("textPrimary"))
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: 92)
        .background(
            Color.gray.opacity(0.05)
        )
        .overlay {

            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color.gray.opacity(0.12),
                    lineWidth: 1
                )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}

#Preview {
    HStack(spacing: 10) {
        StageCard(stage: .screening, count: 12)
        StageCard(stage: .interview, count: 5)
        StageCard(stage: .hired, count: 3)
    }
    .padding()
    .background(Color("background"))
}
