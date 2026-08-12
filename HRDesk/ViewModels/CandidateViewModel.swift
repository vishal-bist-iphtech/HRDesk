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

    @Published var candidates: [Candidate] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchCandidates()
    }

    func fetchCandidates() {

        candidates = coreDataService
            .fetchCandidates()
            .map { Candidate(entity: $0) }
    }

    func addCandidate(
        name: String,
        role: String,
        email: String,
        phone: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
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
            resume: resume,
            job: job
        )

        fetchCandidates()
    }

    func updateCandidate(
        _ candidate: Candidate,
        name: String,
        role: String,
        email: String,
        phone: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
        resume: Data?
    ) {

        coreDataService.updateCandidate(
            id: candidate.id,
            fullName: name,
            role: role,
            email: email,
            phone: phone,
            stage: stage,
            experience: experience,
            matchScore: matchScore,
            appliedDate: candidate.appliedDate,
            resume: resume
        )

        fetchCandidates()
    }

    func moveToStage(
        _ candidate: Candidate,
        stage: PipelineStage
    ) {

        coreDataService.updateCandidateStage(
            id: candidate.id,
            stage: stage
        )

        fetchCandidates()
    }

    func deleteCandidate(_ candidate: Candidate) {

        coreDataService.deleteCandidate(id: candidate.id)

        fetchCandidates()
    }
}
