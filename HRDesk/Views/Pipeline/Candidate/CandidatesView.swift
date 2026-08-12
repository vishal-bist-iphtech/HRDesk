//
//  CandidatesView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct CandidatesView: View {

    @StateObject private var candidateViewModel = CandidateViewModel()

    @State private var searchText = ""
    @State private var showAddCandidate = false
    @State private var editingCandidate: Candidate?

    private var filteredCandidates: [Candidate] {

        guard !searchText.isEmpty else {
            return candidateViewModel.candidates
        }

        return candidateViewModel.candidates.filter {

            $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.role.localizedCaseInsensitiveContains(searchText)
                || $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        NavigationStack {

            Group {

                if candidateViewModel.candidates.isEmpty {

                    ContentUnavailableView(
                        "No Candidates Yet",
                        systemImage: "person.crop.circle.badge.plus",
                        description: Text(
                            "Add a candidate to start building your pipeline."
                        )
                    )

                } else if filteredCandidates.isEmpty {

                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text(
                            "No candidates match \"\(searchText)\"."
                        )
                    )

                } else {

                    ScrollView {

                        LazyVStack(spacing: 12) {

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
                        .padding()
                    }
                }
            }
            .background(
                Color("background")
                    .ignoresSafeArea()
            )
            .navigationTitle("Candidates")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "Search candidates"
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button {

                        showAddCandidate = true

                    } label: {

                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(
                isPresented: $showAddCandidate
            ) {

                NavigationStack {

                    AddCandidateView(
                        defaultJob: nil
                    )
                }
                .environmentObject(candidateViewModel)
            }
            .sheet(
                item: $editingCandidate
            ) { candidate in

                NavigationStack {

                    EditCandidateView(
                        candidate: candidate
                    )
                }
                .environmentObject(candidateViewModel)
            }
            .onAppear {

                candidateViewModel.fetchCandidates()
            }
        }
        .environmentObject(candidateViewModel)
    }
}

#Preview {

    CandidatesView()
}
