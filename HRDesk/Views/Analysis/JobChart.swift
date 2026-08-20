//
//  JobChart.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI
import Charts

struct JobChart: View {
    
    let rows: [AnalyticsViewModel.JobRow]
    let accent: Color

    @Binding var selection: String?

    var body: some View {

        Chart {

            ForEach(rows, id: \.job.objectID) { row in

                let name = row.job.title ?? "Untitled"

                BarMark(
                    x: .value("Candidates", row.candidates),
                    y: .value("Job", name)
                )
                .foregroundStyle(
                    selection == nil || selection == name
                    ? accent.opacity(0.85)
                    : accent.opacity(0.20)
                )
                .cornerRadius(5)
                .annotation(
                    position: .trailing,
                    alignment: .leading
                ) {

                    if selection == name {

                        Text("\(row.candidates)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color("textPrimary"))
                            .padding(.leading, 4)

                    } else if selection == nil {

                        Text("\(row.candidates)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)
                    }
                }
            }
        }
        .chartYSelection(value: $selection)
        .chartPlotStyle { plotArea in

            plotArea
                .padding(.trailing, 28)
        }
        .chartXAxis(.hidden)
        .chartYAxis {

            AxisMarks { value in

                AxisValueLabel {
                    if let name = value.as(String.self) {

                        Text(name)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
        }
        .animation(
            .spring(response: 0.35, dampingFraction: 0.8),
            value: selection
        )
    }
}