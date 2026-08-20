//
//  CandidateDistributionView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct CandidateDistributionView: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    private var slices: [DonutSlice] {

        [
            DonutSlice(
                id: "In Progress",
                label: "In Progress",
                count: analyticsViewModel.inProgressCount,
                color: .orange
            ),
            DonutSlice(
                id: "Hired",
                label: "Hired",
                count: analyticsViewModel.hiredCount,
                color: .green
            ),
            DonutSlice(
                id: "Rejected",
                label: "Rejected",
                count: analyticsViewModel.rejectedCount,
                color: .red
            )
        ]
        .filter {
            $0.count > 0
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            AnalysisSectionHeader(
                title: "Candidate Distribution",
                subtitle: "Current recruitment status across all candidates"
            )

            AnalysisCard {

                if slices.isEmpty {

                    ContentUnavailableView(
                        "No Candidates",
                        systemImage: "person.3"
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: slices,
                        centerTitle: "Candidates",
                        centerSubtitle: "",
                        centerValue: "\(analyticsViewModel.totalCandidates)",
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
    CandidateDistributionView(
        analyticsViewModel: AnalyticsViewModel()
    )
    .padding()
}
