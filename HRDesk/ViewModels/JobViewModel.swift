//
//  JobViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import Foundation
import Combine
import CoreData

final class JobViewModel: ObservableObject {

    @Published var jobs: [JobEntity] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchJobs()
    }

    // MARK: - Fetch

    func fetchJobs() {

        jobs = coreDataService.fetchJobs()
    }

    // MARK: - Add

    func addJob(
        title: String,
        department: String,
        location: String,
        employmentType: String,
        experience: String,
        salary: String,
        jobDescription: String
    ) {

        coreDataService.addJob(
            title: title,
            department: department,
            location: location,
            employmentType: employmentType,
            experience: experience,
            salary: salary,
            jobDescription: jobDescription
        )

        fetchJobs()
    }

    // MARK: - Update

    func updateJob(
        _ job: JobEntity,
        title: String,
        department: String,
        location: String,
        employmentType: String,
        experience: String,
        salary: String,
        jobDescription: String
    ) {

        coreDataService.updateJob(
            job,
            title: title,
            department: department,
            location: location,
            employmentType: employmentType,
            experience: experience,
            salary: salary,
            jobDescription: jobDescription
        )

        fetchJobs()
    }

    // MARK: - Delete

    func deleteJob(_ job: JobEntity) {

        coreDataService.deleteJob(job)

        fetchJobs()
    }
}
