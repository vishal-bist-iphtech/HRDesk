//
//  JobListView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI
import CoreData

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

            VStack(spacing: 0) {
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    
                    HStack {
                        Text("Jobs")
                            .font(.largeTitle.bold())
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Search jobs", text: $searchText)
                            .textFieldStyle(.plain)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(Color(.systemBackground))
                
                // MARK: - Main Content
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
                                    
                                    ForEach(filteredJobs, id: \.objectID) { job in
                                        
                                        NavigationLink {
                                            JobDetailView(job: job)
                                        } label: {
                                            
                                            JobCard(job: job)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    
                    Button {
                        showAddJob = true
                    } label: {
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(Color("background"))
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .sheet(
                isPresented: $showAddJob
            ) {
                
                NavigationStack {
                    AddJobView()
                }
                .environmentObject(jobViewModel)
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
