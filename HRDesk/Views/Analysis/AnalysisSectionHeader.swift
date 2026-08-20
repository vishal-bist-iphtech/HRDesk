//
//  AnalysisSectionHeader.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct AnalysisSectionHeader: View {

    let title: String
    let subtitle: String

    var body: some View {

        VStack(alignment: .leading, spacing: 3) {

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color("textPrimary"))

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    AnalysisSectionHeader(
        title: "Stage Conversion",
        subtitle: "Percentage of candidates moving to the next stage"
    )
    .padding()
}