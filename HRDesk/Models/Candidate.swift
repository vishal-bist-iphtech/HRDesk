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
    let email: String
    let phone: String
    let noticePeriod: String
    let expectedSalary: String
    let location: String
    let website: String?
    let about: String
    let resume: Data
    let experience: String
    let stage: PipelineStage
    let matchScore: Int
    let appliedDate: String
    let jobID: UUID?

    var initials: String {

        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    var employmentType: String {
        "Full-time"
    }

    init(
        id: UUID,
        name: String,
        role: String,
        email: String,
        phone: String,
        experience: String,
        noticePeriod: String,
        expectedSalary: String,
        location: String,
        website: String?,
        about: String,
        resume: Data,
        stage: PipelineStage,
        matchScore: Int,
        appliedDate: String,
        jobID: UUID?,
    ) {

        self.id = id
        self.name = name
        self.role = role
        self.email = email
        self.phone = phone
        self.experience = experience
        self.noticePeriod = noticePeriod
        self.expectedSalary = expectedSalary
        self.location = location
        self.website = website
        self.about = about
        self.resume = resume
        self.stage = stage
        self.matchScore = matchScore
        self.appliedDate = appliedDate
        self.jobID = jobID
    }

    init(entity: CandidateEntity) {

        self.init(
            id: entity.id ?? UUID(),
            name: entity.fullName ?? "",
            role: entity.role ?? "",
            email: entity.email ?? "",
            phone: entity.phone ?? "",
            experience: entity.experience ?? "",
            noticePeriod: entity.noticePeriod ?? "",
            expectedSalary: entity.expectedSalary ?? "",
            location: entity.location ?? "",
            website: entity.website,
            about: entity.about ?? "",
            resume: entity.resumeData ?? Data(),
            stage: PipelineStage(
                rawValue: entity.status ?? ""
            ) ?? .applied,
            matchScore: Int(entity.matchScore),
            appliedDate: entity.appliedDate ?? "",
            jobID: entity.job?.id
        )
    }
}