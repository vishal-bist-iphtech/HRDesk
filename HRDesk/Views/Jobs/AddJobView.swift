//
//  AddJobView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct AddJobView: View {
    
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var jobViewModel: JobViewModel
    
    @State private var jobTitle = ""
    @State private var department = ""
    @State private var location = ""
    @State private var employementType = "Full Time"
    @State private var experience = ""
    @State private var salary = ""
    @State private var description = ""
    
    private let employementTypes = [
        "Full Time",
        "Part Time",
        "Contract",
        "Internship"
    ]
    
    var body: some View {
        
        Form{
            
            Section("Job Details") {
                
                TextField("Job Title", text: $jobTitle)
                TextField("Department", text: $department)
                TextField("Location", text: $location)

                Picker("Employement Type", selection: $employementType) {
                    ForEach(employementTypes, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Experience Required", text: $experience)
                TextField("Expected Salary", text: $salary)
                    .keyboardType(.numberPad)
            }
            
            Section("Job Description") {
                
                TextEditor(text: $description)
                    .frame(minHeight: 150)
            }
            
            Section{
                
                Button {
                    saveJob()
                } label: {
                    Text("Post Job")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(jobTitle.isEmpty)
            }
        }
        .navigationTitle("Post a Job")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func saveJob() {
        
        jobViewModel.addJob(
            title: jobTitle,
            department: department,
            location: location,
            employmentType: employementType,
            experience: experience,
            salary: salary,
            jobDescription: description
        )

        dismiss()
    }
}


#Preview {
    NavigationStack{
        AddJobView()
            .environmentObject(JobViewModel())
    }
}
