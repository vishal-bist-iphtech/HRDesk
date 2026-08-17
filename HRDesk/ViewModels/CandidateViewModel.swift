//
//  CandidateViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import Foundation
import Combine
import CoreData

final class CandidateViewModel: ObservableObject {

    @Published var candidates: [CandidateEntity] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchCandidates()
    }

    func fetchCandidates() {

        candidates = coreDataService.fetchCandidates()
    }

    func addCandidate(
        name: String,
        role: String,
        email: String,
        phone: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
        noticePeriod: String,
        expectedSalary: String,
        about: String,
        location: String,
        website: String?,
        resume: Data?,
        job: JobEntity?
    ) {

        coreDataService.addCandidate(
            fullName: name,
            role: role,
            email: email,
            phone: phone,
            stage: stage,
            experience: experience,
            matchScore: matchScore,
            appliedDate: "Applied \(Date().formatted(date: .abbreviated, time: .omitted))",
            noticePeriod: noticePeriod,
            expectedSalary: expectedSalary,
            about: about,
            location: location,
            website: website,
            resume: resume,
            job: job
        )

        fetchCandidates()
    }

    func updateCandidate(
        _ candidate: CandidateEntity,
        name: String,
        role: String,
        email: String,
        phone: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
        noticePeriod: String,
        expectedSalary: String,
        about: String,
        location: String,
        website: String?,
        resume: Data?
    ) {

        coreDataService.updateCandidate(
            id: candidate.id ?? UUID(),
            fullName: name,
            role: role,
            email: email,
            phone: phone,
            stage: stage,
            experience: experience,
            matchScore: matchScore,
            appliedDate: candidate.appliedDate ?? "",
            noticePeriod: noticePeriod,
            expectedSalary: expectedSalary,
            about: about,
            location: location,
            website: website,
            resume: resume
        )

        fetchCandidates()
    }

    func moveToStage(
        _ candidate: CandidateEntity,
        stage: PipelineStage
    ) {

        coreDataService.updateCandidateStage(
            id: candidate.id ?? UUID(),
            stage: stage
        )

        fetchCandidates()
    }

    func deleteCandidate(_ candidate: CandidateEntity) {

        coreDataService.deleteCandidate(id: candidate.id ?? UUID())

        fetchCandidates()
    }
}
