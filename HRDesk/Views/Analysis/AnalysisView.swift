//
//  AnalysisView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 13/08/26.
//

import SwiftUI

struct AnalysisView: View {

    @EnvironmentObject private var analyticsViewModel: AnalyticsViewModel

    @State private var jobBarSelection: String?

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    header

                    KPISection(analyticsViewModel: analyticsViewModel)

                    FunnelView(analyticsViewModel: analyticsViewModel)

                    StageConversionView(analyticsViewModel: analyticsViewModel)

                    CandidateDistributionView(analyticsViewModel: analyticsViewModel)

                    ApplicationsByJobView(
                        analyticsViewModel: analyticsViewModel,
                        selection: $jobBarSelection
                    )

                    DepartmentHiringView(analyticsViewModel: analyticsViewModel)

                    RejectionReasonsView(analyticsViewModel: analyticsViewModel)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .refreshable {analyticsViewModel.refresh()}
        }
        .onAppear {
            analyticsViewModel.refresh()
        }
    }

    // MARK: - Header

    private var header: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text("Analytics")
                .font(.largeTitle.bold())
                .foregroundStyle(Color("textPrimary"))

            Text("Recruitment performance at a glance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {

    AnalysisView()
        .environmentObject(AnalyticsViewModel())
}
