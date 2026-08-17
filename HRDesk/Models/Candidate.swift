//
//  Candidate.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import Foundation
import CoreData

extension CandidateEntity {

    var name: String {
        fullName ?? ""
    }

    var stage: PipelineStage {
        PipelineStage(rawValue: status ?? "") ?? .applied
    }

    var resume: Data {
        resumeData ?? Data()
    }

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
}