//
//  FunnelView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI

struct FunnelView: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            AnalysisSectionHeader(
                title: "Recruitment Funnel",
                subtitle: "Candidate progression from application to hiring"
            )

            AnalysisCard {

                if analyticsViewModel.totalCandidates == 0 {

                    ContentUnavailableView(
                        "No Candidates",
                        systemImage: "person.3",
                        description: Text(
                            "Candidate data will appear here once applications are added."
                        )
                    )
                    .padding(.vertical, 10)

                } else {

                    RecruitmentChart(
                        stages: analyticsViewModel.funnelStages
                    )

                    HStack {

                        Text("Overall conversion")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(analyticsViewModel.appliedToHired)%")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Color("background"))
                    }
                }
            }
        }
    }
}

#Preview {
    FunnelView(
        analyticsViewModel: AnalyticsViewModel()
    )
    .padding()
}
