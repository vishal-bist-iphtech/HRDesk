//
//  DashboardViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {

    @Published var openJobs = 0
    @Published var applications = 0
    @Published var interviewsToday = 0
    @Published var hiredCandidates = 0

    private let coreDataService = CoreDataService.shared

    func refresh() {

        let activeJobs = coreDataService.countActiveJobs()
        let candidates = coreDataService.countCandidates()
        let hired = coreDataService.countHiredCandidates()
        let interviews = coreDataService.fetchInterviews()

        interviewsToday = interviews.filter {
            Calendar.current.isDateInToday($0.date ?? Date())
        }.count

        openJobs = activeJobs
        applications = candidates
        hiredCandidates = hired
    }
}
