//
//  DonutLegend.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct DonutLegend: View {

    let slices: [DonutSlice]

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            ForEach(slices) { slice in

                HStack(spacing: 8) {

                    Circle()
                        .fill(slice.color)
                        .frame(width: 9, height: 9)

                    Text(slice.label)
                        .font(.caption.weight(.medium))
                        .foregroundStyle( Color("textPrimary"))

                    Spacer()

                    Text("\(slice.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    DonutLegend(
        slices: [
            DonutSlice(
                id: "a",
                label: "In Progress",
                count: 24,
                color: .orange
            ),
            DonutSlice(
                id: "b",
                label: "Hired",
                count: 12,
                color: .green
            )
        ]
    )
    .padding()
}
