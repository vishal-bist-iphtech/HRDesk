//
//  CandidateCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI
import CoreData

struct CandidateCard: View {

    let candidate: CandidateEntity

    var onMoveStage: ((PipelineStage) -> Void)?
    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 12) {

                AvatarView(
                    name: candidate.fullName ?? "Candidate",
                    size: 48,
                    showsMatchBadge: candidate.matchScore >= 80
                )

                VStack(alignment: .leading, spacing: 3) {

                    Text(candidate.fullName ?? "Candidate")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                        .lineLimit(1)

                    Text(candidate.role ?? "NA")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                HStack(alignment: .top, spacing: 6) {

                    ScoreRing(
                        score: candidate.matchScore,
                        size: 40,
                        lineWidth: 3
                    )

                    Menu {

                        Menu {

                            ForEach(
                                PipelineStage.allCases,
                                id: \.self
                            ) { stage in

                                Button {
                                    onMoveStage?(stage)
                                } label: {

                                    if stage == candidate.stage {
                                        Label(
                                            stage.title,
                                            systemImage: "checkmark"
                                        )
                                    } else {
                                        Text(stage.title)
                                    }
                                }
                            }

                        } label: {

                            Label(
                                "Move Stage",
                                systemImage: "arrow.right"
                            )
                        }

                        Button(
                            "Edit Candidate",
                            systemImage: "pencil"
                        ) {
                            onEdit?()
                        }

                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive
                        ) {
                            onDelete?()
                        }

                    } label: {

                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color("textPrimary"))
                            .frame(width: 26, height: 26)
                            .contentShape(
                                RoundedRectangle(cornerRadius: 6)
                            )
                    }
                }
            }

            HStack(spacing: 8) {

                StageBadge(stage: candidate.stage)

                Text(candidate.appliedDate ?? "")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {

                HStack(spacing: 12) {

                    Label(
                        candidate.experience ?? "",
                        systemImage: "person"
                    )
                    .lineLimit(1)

                    Label(
                        candidate.location ?? "",
                        systemImage: "mappin.and.ellipse"
                    )
                    .lineLimit(1)

                    Spacer(minLength: 0)
                    
                    Label(
                        candidate.employmentType,
                        systemImage: "briefcase"
                    )
                }
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .overlay {

            RoundedRectangle(cornerRadius: 12)
            .stroke(
                Color.gray.opacity(0.15)
            )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}

#Preview {
    CandidateCardPreview()
}

private struct CandidateCardPreview: View {
    
    private let candidate: CandidateEntity
    
    init() {
        let context = PersistenceController.preview.container.viewContext
        let candidate = CandidateEntity(context: context)
        candidate.id = UUID()
        candidate.fullName = "Sophia Carter"
        candidate.role = "Product Designer"
        candidate.email = "sophia.carter@hrdesk.com"
        candidate.phone = "(415) 123-4567"
        candidate.experience = "3 Yrs Exp"
        candidate.noticePeriod = "30 Days"
        candidate.expectedSalary = "₹15 LPA"
        candidate.location = "San Francisco, CA"
        candidate.website = "https://www.sophiacarter.com"
        candidate.about = "Product Designer with a passion for user-centered design."
        candidate.resumeData = Data()
        candidate.status = PipelineStage.interview.rawValue
        candidate.matchScore = 92
        candidate.appliedDate = "2 days ago"
        self.candidate = candidate
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                CandidateCard(
                    candidate: candidate,
                    onMoveStage: { stage in
                        print("Moved to stage: \(stage.title)")
                    },
                    onEdit: {
                        print("Edit tapped")
                    },
                    onDelete: {
                        print("Delete tapped")
                    }
                )
            }
            .padding(.horizontal)
        }
    }
}
