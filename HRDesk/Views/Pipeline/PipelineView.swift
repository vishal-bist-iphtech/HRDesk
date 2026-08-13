//
//  PipelineView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct PipelineView: View {

    @EnvironmentObject var jobViewModel: JobViewModel
    @StateObject var candidateViewModel = CandidateViewModel()

    @State var selectedJobIndex = 0
    @State var searchText = ""
    @State var isSearching = false
    @State var sortAscending = false
    @State var showAddCandidate = false
    @State var editingCandidate: Candidate?
    @State var isKanban = false
    @State var newCandidateStage: PipelineStage = .applied

    var selectedJobEntity: JobEntity? {

        if jobViewModel.jobs.indices.contains(selectedJobIndex) {
            return jobViewModel.jobs[selectedJobIndex]
        }

        return nil
    }

    var selectedJob: String {

        selectedJobEntity?.title
            ?? "Product Designer"
    }

    var selectedJobCandidates: [Candidate] {

        guard let selectedJobEntity else {
            return candidateViewModel.candidates
        }

        return candidateViewModel.candidates.filter {
            $0.jobID == selectedJobEntity.id
        }
    }

    var filteredCandidates: [Candidate] {

        var result = selectedJobCandidates

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        if sortAscending {
            result.sort {
                $0.name < $1.name
            }
        }

        return result
    }

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 16) {

                    header

                    if isKanban {

                        searchField

                        kanbanBoard

                    } else {

                        Spacer()

                        selectedJobData

                        filterRow

                        if isSearching {
                            searchField
                        }

                        candidateList
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(
                isPresented: $showAddCandidate
            ) {

                NavigationStack {

                    AddCandidateView(
                        defaultJob: selectedJobEntity,
                        defaultStage: newCandidateStage
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

                jobViewModel.fetchJobs()
                candidateViewModel.fetchCandidates()
            }
        }
        .environmentObject(candidateViewModel)
    }
}

#Preview {

    PipelineView()
        .environmentObject(JobViewModel())
}
