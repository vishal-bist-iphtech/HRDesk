//
//  KPISection.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct KPISection: View {

    @ObservedObject var analyticsViewModel: AnalyticsViewModel

    private var kpiItems: [

        (
            icon: String,
            title: String,
            value: String,
            tint: Color
        )
    ] {

        [
            (
                icon: "person.3.fill",
                title: "Candidates",
                value: "\(analyticsViewModel.totalCandidates)",
                tint: .purple
            ),
            (
                icon: "checkmark.circle.fill",
                title: "Hired",
                value: "\(analyticsViewModel.hiredCount)",
                tint: .green
            ),
            (
                icon: "hourglass.circle.fill",
                title: "In Progress",
                value: "\(analyticsViewModel.inProgressCount)",
                tint: .orange
            ),
            (
                icon: "arrow.up.right.circle.fill",
                title: "Conversion",
                value: "\(analyticsViewModel.appliedToHired)%",
                tint: Color("background")
            )
        ]
    }

    var body: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {

            ForEach(kpiItems, id: \.title) { item in

                StatCard(
                    icon: item.icon,
                    title: item.title,
                    value: item.value,
                    tint: item.tint
                )
            }
        }
    }
}

#Preview {
    KPISection(
        analyticsViewModel: AnalyticsViewModel()
    )
    .padding()
}