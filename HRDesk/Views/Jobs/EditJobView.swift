//
//  EditJobView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI
import CoreData

struct EditJobView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var jobViewModel: JobViewModel

    let job: JobEntity

    @State private var jobTitle: String
    @State private var department: String
    @State private var location: String
    @State private var employmentType: String
    @State private var experience: String
    @State private var salary: String
    @State private var description: String
    @State private var status: String

    init(job: JobEntity) {
        self.job = job

        _jobTitle = State(initialValue: job.title ?? "")
        _department = State(initialValue: job.department ?? "")
        _location = State(initialValue: job.location ?? "")
        _employmentType = State(initialValue: job.employmentType ?? "Full Time")
        _experience = State(initialValue: job.experience ?? "")
        _salary = State(initialValue: job.salaryRange ?? "")
        _description = State(initialValue: job.jd ?? "")
        _status = State(initialValue: job.status ?? "Open")
    }
    
    
    var body: some View {

        Form {

            Section("Job Details") {

                TextField("Job Title", text: $jobTitle)
                TextField("Department", text: $department)
                TextField("Location", text: $location)

                Picker("Employment Type", selection: $employmentType) {
                    ForEach(employmentTypes, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Experience Required", text: $experience)
                TextField("Expected Salary", text: $salary)
            }

            Section("Status") {

                Picker("Job Status", selection: $status) {
                    ForEach(statuses, id: \.self) {
                        Text($0)
                    }
                }
            }

            Section("Job Description") {

                TextEditor(text: $description)
                    .frame(minHeight: 150)
            }

            Section {

                Button {
                    saveJob()
                } label: {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(jobTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("Edit Job")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveJob() {

        jobViewModel.updateJob(
            job,
            title: jobTitle,
            department: department,
            location: location,
            employmentType: employmentType,
            experience: experience,
            salary: salary,
            jobDescription: description,
            status: status
        )

        dismiss()
    }
}

#Preview {

    let context = PersistenceController.preview.container.viewContext
    let job = JobEntity(context: context)
    job.title = "Senior iOS Engineer"
    job.department = "Engineering"
    job.location = "Bengaluru"
    job.employmentType = "Full Time"
    job.experience = "3-5 Years"
    job.salaryRange = "₹18-25 LPA"
    job.jd = "Build and own HRDesk's core features."
    job.status = "Open"
    job.createdAt = Date()
    job.isActive = true

    return NavigationStack {
        EditJobView(job: job)
            .environmentObject(JobViewModel())
    }
}
