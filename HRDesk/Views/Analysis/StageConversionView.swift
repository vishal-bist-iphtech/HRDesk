//
//  StageConversionView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct StageConversionView: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    private var conversionData: [ConversionData] {

        [
            ConversionData(
                stage: "Applied → Screening",
                percentage: analyticsViewModel.appliedToScreening
            ),
            ConversionData(
                stage: "Screening → Interview",
                percentage: analyticsViewModel.screeningToInterview
            ),
            ConversionData(
                stage: "Interview → Offer",
                percentage: analyticsViewModel.interviewToOffer
            ),
            ConversionData(
                stage: "Offer → Hired",
                percentage: analyticsViewModel.offerToHired
            )
        ]
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            AnalysisSectionHeader(
                title: "Stage Conversion",
                subtitle: "Percentage of candidates moving to the next stage"
            )

            AnalysisCard {

                if analyticsViewModel.totalCandidates == 0 {

                    ContentUnavailableView(
                        "No Conversion Data",
                        systemImage: "chart.bar.xaxis"
                    )
                    .padding(.vertical, 10)

                } else {

                    ConversionChart(data: conversionData)
                        .frame(height: 230)
                }
            }
        }
    }
}

#Preview {
    StageConversionView(
        analyticsViewModel: AnalyticsViewModel()
    )
    .padding()
}