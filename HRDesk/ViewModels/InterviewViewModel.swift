//
//  InterviewViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 14/08/26.
//

import Foundation
import Combine
import CoreData

final class InterviewViewModel: ObservableObject {

    @Published var interviews: [Interview] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchInterviews()
    }

    func fetchInterviews() {

        interviews = coreDataService
            .fetchInterviews()
            .map { Interview(entity: $0) }
    }

    func scheduleInterview(
        candidateID: UUID?,
        candidateName: String,
        candidateRole: String,
        interviewType: String,
        date: Date,
        duration: String,
        location: String,
        notes: String,
        interviewers: [Interviewer]
    ) {

        coreDataService.addInterview(
            candidateID: candidateID,
            candidateName: candidateName,
            candidateRole: candidateRole,
            interviewType: interviewType,
            date: date,
            duration: duration,
            location: location,
            notes: notes,
            interviewers: interviewers
        )

        fetchInterviews()
    }

    func deleteInterview(_ interview: Interview) {

        coreDataService.deleteInterview(id: interview.id)

        fetchInterviews()
    }
}
