//
//  ConversionChart.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI
import Charts

struct ConversionChart: View {

    let data: [ConversionData]

    private var maxValue: Int {

        data.map(\.percentage).max() ?? 100
    }

    var body: some View {

        Chart(data, id: \.id) { item in

            BarMark(
                x: .value(
                    "Conversion",
                    item.percentage
                ),
                y: .value(
                    "Stage",
                    item.stage
                )
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color("background").opacity(0.45),
                        Color("background")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(6)
            .annotation(
                position: .overlay,
                alignment: .trailing
            ) {

                Text("\(item.percentage)%")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.trailing, 8)
            }
        }
        .chartXScale(
            domain: 0...max(100, maxValue)
        )
        .chartXAxis(.hidden)
        .chartYAxis {

            AxisMarks { value in

                AxisValueLabel {
                    if let name = value.as(String.self) {

                        Text(name)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color("textPrimary"))
                            .lineLimit(1)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
    }
}

struct ConversionData: Identifiable {

    let id = UUID()

    let stage: String
    let percentage: Int
}

#Preview {
    ConversionChart(
        data: [
            ConversionData(stage: "Applied → Screening", percentage: 80),
            ConversionData(stage: "Screening → Interview", percentage: 45),
            ConversionData(stage: "Interview → Offer", percentage: 30),
            ConversionData(stage: "Offer → Hired", percentage: 22)
        ]
    )
    .frame(height: 220)
    .padding()
}