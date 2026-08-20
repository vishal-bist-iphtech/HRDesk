//
//  DepartmentHiringView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct DepartmentHiringView: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    private var slices: [DonutSlice] {

        analyticsViewModel.departmentCounts.map {

            DonutSlice(
                id: $0.name,
                label: $0.name,
                count: $0.count,
                color: $0.color
            )
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            AnalysisSectionHeader(
                title: "Department-Wise Hiring",
                subtitle: "Hired employees distributed across departments"
            )

            AnalysisCard {

                if slices.isEmpty {

                    ContentUnavailableView(
                        "No Hiring Data",
                        systemImage: "person.3",
                        description: Text(
                            "Department hiring data will appear after employees are added."
                        )
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: slices,
                        centerTitle: "Total",
                        centerSubtitle: "Hired",
                        innerRadiusRatio: 0.64
                    )
                    .frame(height: 230)

                    DonutLegend(slices: slices)
                }
            }
        }
    }
}

#Preview {
    DepartmentHiringView(
        analyticsViewModel: AnalyticsViewModel()
    )
    .padding()
}