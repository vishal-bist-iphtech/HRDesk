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
    
    @Published var interviewType = "Technical Interview"
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    @Published var duration = "60 minutes"
    @Published var location = "Google Meet"
    @Published var notes = ""

    @Published var selectedCandidateID: UUID?
    @Published var selectedInterviewerIDs: [UUID] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchInterviews()
    }

    func fetchInterviews() {

        interviews = coreDataService.fetchInterviews()
    }

    func scheduleInterview(
        candidateID: UUID?,
        interviewType: String,
        date: Date,
        duration: String,
        location: String,
        notes: String,
        interviewerIDs: [UUID]
    ) -> UUID? {

        let interviewID = coreDataService.addInterview(
            candidateID: candidateID,
            interviewType: interviewType,
            date: date,
            duration: duration,
            location: location,
            notes: notes,
            interviewerIDs: interviewerIDs
        )

        fetchInterviews()

        if let interviewID,
           let interview = interviews.first(where: { $0.id == interviewID }) {
            NotificationService.shared.scheduleInterviewNotification(
                for: interview
            )
            NotificationService.shared.sendInterviewScheduledNotification(
                for: interview
            )
        }

        return interviewID
    }

    func deleteInterview(_ interview: InterviewEntity) {
        
        guard let id = interview.id else {return}

        NotificationService.shared.cancelInterviewNotification(for: interview)

        coreDataService.deleteInterview(id: id)

        fetchInterviews()
    }

    func markAsDone(_ interview: InterviewEntity) {
        
        guard let id = interview.id else {return}

        coreDataService.updateInterviewStatus(
            id: id,
            status: "Done"
        )

        fetchInterviews()

        NotificationService.shared.cancelInterviewNotification(for: interview)
    }

    func setDone(
        interviewID: UUID?,
        done: Bool
    ) {

        guard let interviewID else {return}

        coreDataService.updateInterviewStatus(
            id: interviewID,
            status: done ? "Done" : "Scheduled"
        )

        fetchInterviews()

        if let interview = interviews.first(where: { $0.id == interviewID }) {
            syncNotification(for: interview)
        }
    }

    func reschedule(
        _ interview: InterviewEntity,
        to date: Date
    ) {
        guard let id = interview.id else {return}

        coreDataService.updateInterviewDate(
            id: id,
            date: date
        )

        fetchInterviews()

        if let updated = interviews.first(where: { $0.id == id }) {
            syncNotification(for: updated)
        }
    }

    func moveToStatus(
        _ interview: InterviewEntity,
        status: String
    ) {

        guard let id = interview.id else { return }

        coreDataService.updateInterviewStatus(
            id: id,
            status: status
        )

        fetchInterviews()

        if let updated = interviews.first(where: { $0.id == id }) {
            syncNotification(for: updated)
        }
    }

    func updateInterview(
        _ interview: InterviewEntity,
        interviewType: String,
        date: Date,
        duration: String,
        location: String,
        notes: String,
        interviewerIDs: [UUID]
    ) {

        guard let id = interview.id else { return }

        coreDataService.updateInterview(
            id: id,
            interviewType: interviewType,
            date: date,
            duration: duration,
            location: location,
            notes: notes,
            interviewerIDs: interviewerIDs
        )

        fetchInterviews()

        if let updated = interviews.first(where: { $0.id == id }) {
            syncNotification(for: updated)
        }
    }

    // MARK: - Notifications

    private func syncNotification(for interview: InterviewEntity) {

        if (interview.status ?? "Scheduled") == "Done" {
            NotificationService.shared.cancelInterviewNotification(for: interview)
        } else {
            NotificationService.shared.scheduleInterviewNotification(for: interview)
        }
    }
}
