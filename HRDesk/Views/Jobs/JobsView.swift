//
//  JobListView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct JobsView: View {

    @EnvironmentObject private var jobViewModel: JobViewModel

    @State private var showAddJob = false
    @State private var searchText = ""

    private var filteredJobs: [JobEntity] {

        guard !searchText.isEmpty else {
            return jobViewModel.jobs
        }

        return jobViewModel.jobs.filter { job in

            let query = searchText.lowercased()

            return job.title?.lowercased().contains(query) == true
                || job.department?.lowercased().contains(query) == true
                || job.location?.lowercased().contains(query) == true
                || job.employmentType?.lowercased().contains(query) == true
                || job.experience?.lowercased().contains(query) == true
        }
    }

    var body: some View {

        NavigationStack {

            ZStack(alignment: .bottomTrailing) {

                Group {

                    if jobViewModel.jobs.isEmpty {

                        ContentUnavailableView(
                            "No Jobs Posted",
                            systemImage: "briefcase",
                            description: Text(
                                "Tap + to post your first job."
                            )
                        )

                    } else if filteredJobs.isEmpty {

                        ContentUnavailableView(
                            "No Results",
                            systemImage: "magnifyingglass",
                            description: Text(
                                "No jobs match \"\(searchText)\"."
                            )
                        )

                    } else {

                        ScrollView {

                            LazyVStack(spacing: 16) {

                                ForEach(
                                    filteredJobs,
                                    id: \.objectID
                                ) { job in

                                    NavigationLink {

                                        JobDetailView(
                                            job: job
                                        )

                                    } label: {

                                        JobCard(
                                            job: job
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding()
                        }
                    }
                }

                // MARK: - Add Job Button

                Button {

                    showAddJob = true

                } label: {

                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(
                            width: 60,
                            height: 60
                        )
                        .background(
                            Color("textSecondary")
                        )
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
                .padding()
            }
            .background(
                Color("background")
                    .ignoresSafeArea()
            )
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "Search jobs"
            )
            .navigationTitle("Jobs")
            .navigationBarTitleDisplayMode(.large)
            .sheet(
                isPresented: $showAddJob
            ) {

                NavigationStack {

                    AddJobView()
                }
                .environmentObject(
                    jobViewModel
                )
            }
        }
        .onAppear {

            jobViewModel.fetchJobs()
        }
    }
}

#Preview {

    NavigationStack {

        JobsView()
            .environmentObject(
                JobViewModel()
            )
    }
}
