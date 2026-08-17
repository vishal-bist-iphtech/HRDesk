//
//  KanbanBoardView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI
import CoreData

struct KanbanBoardView: View {

    let candidates: [CandidateEntity]

    var onMoveStage: (CandidateEntity, PipelineStage) -> Void
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
    let allCandidates: [CandidateEntity]

    var onMoveStage: (CandidateEntity, PipelineStage) -> Void
    var onAddCandidate: ((PipelineStage) -> Void)?

    private let columnHeight: CGFloat = 310

    private var stageCandidates: [CandidateEntity] {

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
                            .draggable(candidate.id?.uuidString ?? "")
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


#Preview {
    KanbanBoardPreview()
}

private struct KanbanBoardPreview: View {

    private let candidates: [CandidateEntity]

    init() {
        let context = PersistenceController.preview.container.viewContext

        let candidate = CandidateEntity(context: context)
        candidate.id = UUID()
        candidate.fullName = "Sophia Carter"
        candidate.role = "Product Designer"
        candidate.email = "sophia@gmail.com"
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

        let candidate2 = CandidateEntity(context: context)
        candidate2.id = UUID()
        candidate2.fullName = "Liam Anderson"
        candidate2.role = "Product Designer"
        candidate2.email = "liam@gmail.com"
        candidate2.phone = "(212) 555-1234"
        candidate2.experience = "4 Yrs Exp"
        candidate2.noticePeriod = "45 Days"
        candidate2.expectedSalary = "₹14 LPA"
        candidate2.location = "New York, NY"
        candidate2.website = nil
        candidate2.about = "Product Designer focused on design systems."
        candidate2.resumeData = Data()
        candidate2.status = PipelineStage.screening.rawValue
        candidate2.matchScore = 88
        candidate2.appliedDate = "1 day ago"

        self.candidates = [candidate, candidate2]
    }

    var body: some View {
        KanbanBoardView(
            candidates: candidates,
            onMoveStage: { _, _ in }
        )
        .padding()
        .background(Color("background"))
    }
}
