//
//  CandidateCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct CandidateCard: View {

    let candidate: Candidate

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack(
                alignment: .top,
                spacing: 12
            ) {

                AvatarView(
                    candidate: candidate,
                    size: 48,
                    showFavoriteBadge: true
                )

                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {

                    Text(candidate.name)
                        .font(
                            .subheadline.weight(.semibold)
                        )
                        .foregroundStyle(
                            Color("textPrimary")
                        )

                    Text(candidate.role)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                ScoreRing(
                    score: candidate.matchScore,
                    size: 46,
                    lineWidth: 3
                )

                Menu {

                    Button(
                        "View Details",
                        systemImage: "eye"
                    ) {}

                    Button(
                        "Move Stage",
                        systemImage: "arrow.right"
                    ) {}

                    Button(
                        "Edit Candidate",
                        systemImage: "pencil"
                    ) {}

                } label: {

                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                        .frame(width: 28, height: 28)
                }
            }

            HStack(spacing: 8) {

                StageBadge(stage: candidate.stage)

                Text("•")
                    .foregroundStyle(.secondary)

                Text(candidate.appliedDate)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {

                Label(
                    candidate.experience,
                    systemImage: "briefcase"
                )

                Label(
                    candidate.location,
                    systemImage: "mappin.and.ellipse"
                )

                Label(
                    candidate.employmentType,
                    systemImage: "person"
                )
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 4)
        .overlay {

            RoundedRectangle(cornerRadius: 9)
            .stroke(
                Color.gray.opacity(0.3)
            )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 9)
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(Candidate.samples.prefix(3)) { candidate in
            CandidateCard(candidate: candidate)
        }
    }
    .padding(.horizontal)
    .background(Color("background"))
}
