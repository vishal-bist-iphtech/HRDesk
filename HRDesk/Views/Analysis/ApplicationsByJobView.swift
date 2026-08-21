//
//  ApplicationsByJobView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct ApplicationsByJobView: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    @Binding var selection: String?

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            AnalysisSectionHeader(
                title: "Applications by Job",
                subtitle: "Number of candidates applying for each position"
            )

            AnalysisCard {

                if analyticsViewModel.jobRows.isEmpty {

                    ContentUnavailableView(
                        "No Jobs Posted",
                        systemImage: "briefcase",
                        description: Text("Post a job to start receiving applications.")
                    )
                    .padding(.vertical, 20)

                } else {

                    selectedJobReadout

                    JobChart(
                        rows: analyticsViewModel.jobRows,
                        accent: Color("background"),
                        selection: $selection
                    )
                    .frame(
                        height: max(180,CGFloat(analyticsViewModel.jobRows.count) * 45)
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var selectedJobReadout: some View {

        if let selection,
           let row = analyticsViewModel.jobRows.first(
                where: {
                    ($0.job.title ?? "Untitled") == selection
                }
           ) {

            HStack(spacing: 8) {

                Image(systemName: "briefcase.fill")
                    .font(.caption)
                    .foregroundStyle(Color("background"))

                Text(row.job.title ?? "Untitled")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary"))
                    .lineLimit(1)

                Spacer()

                Text("\(row.candidates) candidate\(row.candidates == 1 ? "" : "s")")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color("background"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color("background").opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))

        } else {

            Text("Tap a bar to see job details")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ApplicationsByJobView(
        analyticsViewModel: AnalyticsViewModel(),
        selection: .constant(nil)
    )
    .padding()
}
