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

    @Published var interviews: [InterviewEntity] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchInterviews()
    }

    func fetchInterviews() {

        interviews = coreDataService.fetchInterviews()
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
    ) -> UUID? {

        let interviewID = coreDataService.addInterview(
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

        return interviewID
    }

    func deleteInterview(_ interview: InterviewEntity) {

        coreDataService.deleteInterview(id: interview.id ?? UUID())

        fetchInterviews()
    }

    func markAsDone(_ interview: InterviewEntity) {

        coreDataService.updateInterviewStatus(
            id: interview.id ?? UUID(),
            status: "Done"
        )

        fetchInterviews()
    }

    func setDone(
        interviewID: UUID?,
        done: Bool
    ) {

        guard let interviewID else {
            return
        }

        coreDataService.updateInterviewStatus(
            id: interviewID,
            status: done ? "Done" : "Scheduled"
        )

        fetchInterviews()
    }

    func reschedule(
        _ interview: InterviewEntity,
        to date: Date
    ) {

        coreDataService.updateInterviewDate(
            id: interview.id ?? UUID(),
            date: date
        )

        fetchInterviews()
    }
}
