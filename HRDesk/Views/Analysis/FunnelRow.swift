//
//  FunnelRow.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI

struct FunnelStage: Identifiable {

    let name: String
    let count: Int
    let color: Color

    var id: String { name }
}

struct FunnelRow: Identifiable {

    let id: String
    let name: String
    let stages: [FunnelStage]
}

struct FunnelCell: View {

    let name: String
    let count: Int
    let color: Color
    let normalizedHeight: CGFloat

    var body: some View {

        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(0.30 + 0.55 * normalizedHeight),
                        color.opacity(0.20)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: max(16, 44 * normalizedHeight))
            .overlay {

                if count > 0 {

                    Text("\(count)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                }
            }
            .accessibilityLabel("\(name): \(count)")
    }
}