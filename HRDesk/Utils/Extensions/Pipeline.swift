//
//  Pipeline.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI
import CoreData

extension PipelineView {

    var header: some View {

        HStack(alignment: .center, spacing: 12) {

            VStack(alignment: .leading, spacing: 2) {

                Text("Pipeline")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color("textPrimary"))

                Menu {

                    ForEach(
                        Array(jobViewModel.jobs.enumerated()),
                        id: \.element.objectID
                    ) { index, job in

                        Button {
                            selectedJobIndex = index
                        } label: {

                            Text(
                                job.title ?? "Untitled Job"
                            )
                        }
                    }

                } label: {

                    HStack(spacing: 3) {

                        Text(selectedJob)
                            .font(.headline.weight(.medium))

                        Image(
                            systemName: "chevron.down"
                        )
                        .font(.caption.bold())
                    }
                    .foregroundStyle(
                        Color("textSecondary")
                    )
                }
            }

            Spacer()

            Button {

                isKanban.toggle()

            } label: {

                Image(
                    systemName:
                        isKanban
                        ? "square.grid.2x2.fill"
                        : "hand.point.up.left.fill"
                )
                .font(.title2)
                .frame(width: 36, height: 36)
                .foregroundStyle(.white)
                .background(Color("textSecondary"))
                .clipShape(Circle())
            }

            Button {

                newCandidateStage = .applied
                showAddCandidate = true

            } label: {

                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Color("textSecondary"))
                    .clipShape(Circle())
            }
        }
    }

    var stageSelector: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 10) {

                ForEach(
                    PipelineStage.allCases,
                    id: \.self
                ) { stage in

                    StageCard(
                        stage: stage,
                        count: selectedJobCandidates.filter {
                            $0.stage == stage
                        }.count
                    )
                    .frame(width: 110)
                }
            }
        }
    }

    var filterRow: some View {

        HStack(spacing: 8) {

            Menu {

                Button("Latest") {
                    sortAscending = true
                }

                Button("Last") {
                    sortAscending = false
                }

            } label: {

                HStack(spacing: 3) {

                    Text("Sort:")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    Text(
                        sortAscending
                        ? "Latest"
                        : "Last"
                    )
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color("textPrimary"))

                    Image(
                        systemName: "chevron.down"
                    )
                    .font(.caption.weight(.medium))
                }
            }

            Spacer()

            Text(
                "\(filteredCandidates.count) Candidates"
            )
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.secondary)

            Button {

                withAnimation(.easeInOut(duration: 0.2)) {
                    isSearching.toggle()
                }

            } label: {

                Image(
                    systemName:
                        isSearching
                        ? "xmark"
                        : "magnifyingglass"
                )
                .font(.subheadline.bold())
                .foregroundStyle(Color("textPrimary"))
            }
        }
    }

    var searchField: some View {

        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField(
                "Search candidates",
                text: $searchText
            )
            .font(.subheadline)
            .autocorrectionDisabled()

            if !searchText.isEmpty {

                Button {

                    searchText = ""

                } label: {

                    Image(
                        systemName: "xmark.circle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.035))
        .overlay {

            RoundedRectangle(cornerRadius: 9)
            .stroke(
                Color.gray.opacity(0.10),
                lineWidth: 1
            )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 9)
        )
    }

    var candidateList: some View {

        LazyVStack(spacing: 6) {

            ForEach(filteredCandidates) { candidate in

                NavigationLink {

                    CandidateDetailView(
                        candidate: candidate
                    )

                } label: {

                    CandidateCard(
                        candidate: candidate,
                        onMoveStage: { newStage in

                            candidateViewModel.moveToStage(
                                candidate,
                                stage: newStage
                            )
                        },
                        onEdit: {

                            editingCandidate = candidate
                        },
                        onDelete: {

                            candidateViewModel.deleteCandidate(
                                candidate
                            )
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    var kanbanBoard: some View {

        KanbanBoardView(
            candidates: filteredCandidates,
            onMoveStage: { candidate, stage in

                candidateViewModel.moveToStage(
                    candidate,
                    stage: stage
                )
            },
            onAddCandidate: { stage in

                newCandidateStage = stage
                showAddCandidate = true
            }
        )
    }
}
