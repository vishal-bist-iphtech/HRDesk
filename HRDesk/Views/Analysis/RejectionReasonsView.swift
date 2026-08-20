//
//  RejectionReasonsView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct RejectionReasonsView: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    private var slices: [DonutSlice] {

        analyticsViewModel.rejectionSlices.map {

            DonutSlice(
                id: $0.reason,
                label: $0.reason,
                count: $0.count,
                color: $0.color
            )
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            AnalysisSectionHeader(
                title: "Rejection Reasons",
                subtitle: "Why candidates or offers were rejected"
            )

            AnalysisCard {

                if slices.isEmpty {

                    ContentUnavailableView(
                        "No Rejections Yet",
                        systemImage: "hand.thumbsdown",
                        description: Text(
                            "Rejection data will appear as candidates are rejected."
                        )
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: slices,
                        centerTitle: "Total",
                        centerSubtitle: "Rejected",
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
    RejectionReasonsView(
        analyticsViewModel: AnalyticsViewModel()
    )
    .padding()
}