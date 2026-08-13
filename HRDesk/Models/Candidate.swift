//
//  Candidate.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import Foundation

struct Candidate: Identifiable {

    let id: UUID

    let name: String
    let role: String
    let stage: PipelineStage
    let experience: String
    let matchScore: Int
    let appliedDate: String
    let email: String
    let phone: String
    let noticePeriod: String
    let expectedSalary: String
    let jobID: UUID?
    let hasResume: Bool

    var initials: String {

        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    var about: String {
        "A passionate \(role) with \(experience). Known for strong product thinking, cross-functional collaboration, and delivering high-quality, user-centered solutions."
    }

    var location: String {
        "San Francisco, CA"
    }

    var website: String {
        "https://www.\(name.lowercased().replacingOccurrences(of: " ", with: "-")).com"
    }

    var employmentType: String {
        "Full-time"
    }

    init(
        id: UUID,
        name: String,
        role: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
        appliedDate: String,
        email: String,
        phone: String,
        noticePeriod: String,
        expectedSalary: String,
        jobID: UUID?,
        hasResume: Bool
    ) {

        self.id = id
        self.name = name
        self.role = role
        self.stage = stage
        self.experience = experience
        self.matchScore = matchScore
        self.appliedDate = appliedDate
        self.email = email
        self.phone = phone
        self.noticePeriod = noticePeriod
        self.expectedSalary = expectedSalary
        self.jobID = jobID
        self.hasResume = hasResume
    }

    init(entity: CandidateEntity) {

        self.init(
            id: entity.id ?? UUID(),
            name: entity.fullName ?? "",
            role: entity.role ?? "",
            stage: PipelineStage(
                rawValue: entity.status ?? ""
            ) ?? .applied,
            experience: entity.experience ?? "",
            matchScore: Int(entity.matchScore),
            appliedDate: entity.appliedDate ?? "",
            email: entity.email ?? "",
            phone: entity.phone ?? "",
            noticePeriod: entity.noticePeriod ?? "",
            expectedSalary: entity.expectedSalary ?? "",
            jobID: entity.job?.id,
            hasResume: (entity.resumeData?.isEmpty == false)
        )
    }
}
