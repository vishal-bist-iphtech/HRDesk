//
//  StageBadge.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct StageBadge: View {

    let stage: PipelineStage

    var body: some View {

        Text(stage.title)
            .font(.caption2.weight(.medium))
            .foregroundStyle(stage.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(stage.color.opacity(0.12))
            .clipShape(Capsule())
    }
}

#Preview {
    HStack(spacing: 8) {
        ForEach(PipelineStage.allCases, id: \.self) { stage in
            StageBadge(stage: stage)
        }
    }
}
