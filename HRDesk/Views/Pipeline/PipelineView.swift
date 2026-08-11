//
//  PipelineView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct PipelineView: View {

    @EnvironmentObject var jobViewModel: JobViewModel

    @State var selectedJobIndex = 0
    @State var selectedStage = PipelineStage.applied
    @State var searchText = ""
    @State var isSearching = false
    @State var sortAscending = false

    let candidates = Candidate.samples

    var selectedJob: String {

        if jobViewModel.jobs.indices.contains(selectedJobIndex) {
            return jobViewModel.jobs[selectedJobIndex].title
                ?? "Product Designer"
        }

        return "Product Designer"
    }

    var filteredCandidates: [Candidate] {

        var result = candidates.filter {
            $0.stage == selectedStage
        }

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

                VStack(
                    alignment: .leading,
                    spacing: 16
                ) {

                    header
                    Spacer()
                    stageSelector

                    filterRow

                    if isSearching {
                        searchField
                    }

                    candidateList
                }
                .padding()
            }
            .background(Color("background")
                    .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
}

#Preview {

    PipelineView()
        .environmentObject(JobViewModel())
}
