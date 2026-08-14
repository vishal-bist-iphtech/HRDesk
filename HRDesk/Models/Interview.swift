//
//  Interview.swift
//  HRDesk
//
//  Created by iPHTech 34 on 14/08/26.
//

import Foundation

struct Interview: Identifiable {

    let id: UUID
    let candidateID: UUID?
    let candidateName: String
    let candidateRole: String
    let interviewType: String
    let date: Date
    let duration: String
    let location: String
    let notes: String
    let status: String
    let interviewers: [Interviewer]
    let createdAt: Date

    var initials: String {

        candidateName.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    init(
        id: UUID,
        candidateID: UUID?,
        candidateName: String,
        candidateRole: String,
        interviewType: String,
        date: Date,
        duration: String,
        location: String,
        notes: String,
        status: String,
        interviewers: [Interviewer],
        createdAt: Date
    ) {

        self.id = id
        self.candidateID = candidateID
        self.candidateName = candidateName
        self.candidateRole = candidateRole
        self.interviewType = interviewType
        self.date = date
        self.duration = duration
        self.location = location
        self.notes = notes
        self.status = status
        self.interviewers = interviewers
        self.createdAt = createdAt
    }

    init(entity: InterviewEntity) {

        self.init(
            id: entity.id ?? UUID(),
            candidateID: entity.candidateID,
            candidateName: entity.candidateName ?? "",
            candidateRole: entity.candidateRole ?? "",
            interviewType: entity.interviewType ?? "",
            date: entity.date ?? Date(),
            duration: entity.duration ?? "",
            location: entity.location ?? "",
            notes: entity.notes ?? "",
            status: entity.status ?? "Scheduled",
            interviewers: Interviewer.decode(
                names: entity.interviewerNames ?? "",
                roles: entity.interviewerRoles ?? ""
            ),
            createdAt: entity.createdAt ?? Date()
        )
    }
}

struct Interviewer: Identifiable {

    let id = UUID()
    let name: String
    let role: String
    let employeeID: UUID?

    var initials: String {

        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    init(
        name: String,
        role: String,
        employeeID: UUID? = nil
    ) {

        self.name = name
        self.role = role
        self.employeeID = employeeID
    }

    static func decode(
        names: String,
        roles: String
    ) -> [Interviewer] {

        let nameList = names.split(separator: "|").map(String.init)
        let roleList = roles.split(separator: "|").map(String.init)

        guard nameList.count == roleList.count else {
            return []
        }

        return nameList.enumerated().map { index, name in

            Interviewer(
                name: name,
                role: roleList[index]
            )
        }
    }
}
