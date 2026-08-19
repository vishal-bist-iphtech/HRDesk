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
                    x: .value("Job", name),
                    y: .value("Candidates", row.candidates)
                )
                .foregroundStyle(
                    selection == nil || selection == name
                    ? accent.opacity(0.85)
                    : accent.opacity(0.20)
                )
                .cornerRadius(5)
                .annotation(position: .top) {

                    if selection == name {

                        Text("\(row.candidates)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color("textPrimary"))
                    }
                }
            }
        }
        .chartXSelection(value: $selection)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks {
                AxisGridLine()
                    .foregroundStyle(Color.gray.opacity(0.15))
                AxisValueLabel()
                    .font(.caption2)
            }
        }
        .animation(.snappy, value: selection)
    }
}
