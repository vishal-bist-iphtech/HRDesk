//
//  HelpSupportView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct HelpSupportView: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 20) {

                CardContainer(padding: 4) {

                    VStack(spacing: 0) {

                        faqRow(
                            icon: "calendar.badge.plus",
                            title: "How do I schedule an interview?",
                            detail: "Open the Candidates tab, choose a candidate and tap Schedule Interview."
                        )

                        Divider()
                            .padding(.leading, 52)

                        faqRow(
                            icon: "briefcase.fill",
                            title: "How do I post a new job?",
                            detail: "Go to the Jobs tab and tap the + button to create a new posting."
                        )

                        Divider()
                            .padding(.leading, 52)

                        faqRow(
                            icon: "chart.bar.fill",
                            title: "Where can I see my hiring performance?",
                            detail: "Open the Analysis tab to view your recruitment funnel and conversion metrics."
                        )
                    }
                }

                CardContainer {

                    VStack(alignment: .leading, spacing: 12) {

                        Label("Contact Support", systemImage: "envelope.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color("textPrimary"))

                        Text("support@hrdesk.com")
                            .font(.subheadline)
                            .foregroundStyle(Color("background"))

                        Text("Response time: within 24 hours")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func faqRow(
        icon: String,
        title: String,
        detail: String
    ) -> some View {

        HStack(alignment: .top, spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Color("background"))
                .clipShape(RoundedRectangle(cornerRadius: 9))

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary"))

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
    }
}

#Preview {
    NavigationStack {
        HelpSupportView()
    }
}