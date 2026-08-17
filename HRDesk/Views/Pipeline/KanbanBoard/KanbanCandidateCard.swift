//
//  KanbanCandidateView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI


struct KanbanCandidateCard: View {

    let candidate: CandidateEntity

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack(spacing: 10) {

                AvatarView(
                    name: candidate.name,
                    size: 36,
                    showsMatchBadge: candidate.matchScore >= 80
                )

                Text(candidate.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }

            HStack(spacing: 4) {

                Label(
                    candidate.experience ?? "",
                    systemImage: "briefcase"
                )
                .font(.system(size: 12))
                .lineLimit(1)

//                Spacer()
//
//                Text("\(candidate.matchScore)%")
//                    .font(.system(size: 12, weight: .semibold))
//                    .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.4))
            }
            .foregroundColor(.secondary)

            Label(
                candidate.appliedDate ?? "",
                systemImage: "clock"
            )
            .font(.system(size: 11))
            .foregroundColor(.secondary.opacity(0.8))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6).opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
