//
//  FunnelView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI

struct FunnelView: View {
    
    let funnelData: [FunnelRow]

    private var stageColumns: [String] {

        funnelData.first?.stages.map(\.name)
            ?? PipelineStage.allCases
                .filter { $0 != .rejected }
                .map(\.title)
    }

    var body: some View {

        Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 8) {

            GridRow {

                Text("Job")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)

                ForEach(stageColumns, id: \.self) { name in

                    Text(name)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            ForEach(funnelData) { row in

                GridRow {

                    Text(row.name)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Color("textPrimary"))
                        .lineLimit(2)

                    ForEach(row.stages) { stage in

                        let ratio = row.stages.map(\.count).max() ?? 1

                        Text(stage.count > 0 ? "\(stage.count)" : "–")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Color("textPrimary"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(
                                stage.color.opacity(stage.count > 0
                                    ? 0.15 + 0.5 * Double(stage.count) / Double(ratio)
                                    : 0.05)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }
}
