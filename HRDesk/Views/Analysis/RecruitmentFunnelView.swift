//
//  RecruitmentFunnelView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//
import SwiftUI

struct RecruitmentFunnelView: View {
    
    let funnelData: [FunnelRow]

    private var stageColumns: [String] {

        funnelData.first?.stages.map(\.name)
            ?? PipelineStage.allCases
                .filter { $0 != .rejected }
                .map(\.title)
    }

    private func maxCount(in row: FunnelRow) -> Int {

        row.stages.map(\.count).max() ?? 1
    }

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            VStack(alignment: .leading, spacing: 10) {

                HStack(spacing: 8) {

                    Color.clear
                        .frame(width: 110)

                    HStack(spacing: 4) {

                        ForEach(stageColumns, id: \.self) { name in

                            Text(name)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }

                ForEach(funnelData) { row in

                    HStack(spacing: 8) {

                        Text(row.name)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Color("textPrimary"))
                            .lineLimit(2)
                            .frame(width: 110, alignment: .leading)

                        HStack(spacing: 4) {

                            ForEach(row.stages) { stage in

                                FunnelCell(
                                    name: stage.name,
                                    count: stage.count,
                                    color: stage.color,
                                    normalizedHeight: CGFloat(stage.count)
                                        / CGFloat(maxCount(in: row))
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}
