//
//  KanbanBoardView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI

struct KanbanBoardView: View {

    let candidates: [Candidate]

    var onMoveStage: (Candidate, PipelineStage) -> Void
    var onAddCandidate: ((PipelineStage) -> Void)?

    private let stages: [PipelineStage] = [
        .applied, .screening, .interview, .offer, .hired, .rejected
    ]

    var body: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            alignment: .leading,
            spacing: 14
        ) {

            ForEach(stages, id: \.self) { stage in

                KanbanStageColumn(
                    stage: stage,
                    allCandidates: candidates,
                    onMoveStage: onMoveStage,
                    onAddCandidate: onAddCandidate
                )
            }
        }
    }
}

struct KanbanStageColumn: View {

    let stage: PipelineStage
    let allCandidates: [Candidate]

    var onMoveStage: (Candidate, PipelineStage) -> Void
    var onAddCandidate: ((PipelineStage) -> Void)?

    private let columnHeight: CGFloat = 310

    private var stageCandidates: [Candidate] {

        allCandidates.filter {
            $0.stage == stage
        }
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            headerPill

            ScrollView(.vertical, showsIndicators: false) {

                LazyVStack(spacing: 8) {

                    ForEach(stageCandidates) { candidate in

                        NavigationLink {

                            CandidateDetailView(
                                candidate: candidate
                            )

                        } label: {

                            KanbanCandidateCard(
                                candidate: candidate
                            )
                            .draggable(candidate.id.uuidString)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            }

            if stage != .rejected, let onAddCandidate {

                Button {
                    onAddCandidate(stage)
                } label: {

                    HStack(spacing: 4) {

                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))

                        Text("Add Candidate")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(stage.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 6)
            }
        }
        .frame(height: columnHeight, alignment: .top)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        }
        .dropDestination(for: String.self) { items, _ in

            guard let idString = items.first,
                  let id = UUID(uuidString: idString),
                  let candidate = allCandidates.first(where: { $0.id == id }) else {
                return false
            }

            onMoveStage(candidate, stage)

            return true
        }
    }

    private var headerPill: some View {

        HStack {

            Text(stage.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(stage.color)

            Spacer()

            Text(String(format: "%02d", stageCandidates.count))
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(stage.color.opacity(0.9))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(stage.color.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
}

struct KanbanCandidateCard: View {

    let candidate: Candidate

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack(spacing: 10) {

                AvatarView(
                    name: candidate.name,
                    size: 36
                )

                Text(candidate.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Spacer(minLength: 4)

                Image(systemName: "ellipsis")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(90))
            }

            HStack(spacing: 4) {

                Label(
                    candidate.experience,
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
                candidate.appliedDate,
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

#Preview {

    KanbanBoardView(
        candidates: [
            Candidate(
                id: UUID(),
                name: "Sophia Carter",
                role: "Product Designer",
                stage: .interview,
                experience: "3 Yrs Exp",
                matchScore: 92,
                appliedDate: "2 days ago",
                email: "sophia@gmail.com",
                phone: "(415) 123-4567",
                jobID: nil,
                hasResume: true
            ),
            Candidate(
                id: UUID(),
                name: "Liam Anderson",
                role: "Product Designer",
                stage: .screening,
                experience: "4 Yrs Exp",
                matchScore: 88,
                appliedDate: "1 day ago",
                email: "liam@gmail.com",
                phone: "(212) 555-1234",
                jobID: nil,
                hasResume: true
            )
        ],
        onMoveStage: { _, _ in }
    )
    .padding()
    .background(Color("background"))
}
