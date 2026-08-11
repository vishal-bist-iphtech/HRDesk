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

    private let DummyOpenJobs = 12
    private let DummyApplications = 48
    private let DummyInterviewsToday = 16
    private let DummyHiredCandidates = 8

    func refresh() {

        let activeJobs = coreDataService.countActiveJobs()
        let candidates = coreDataService.countCandidates()
        let hired = coreDataService.countHiredCandidates()

        openJobs = activeJobs > 0 ? activeJobs : DummyOpenJobs
        applications = candidates > 0 ? candidates : DummyApplications
        interviewsToday = DummyInterviewsToday
        hiredCandidates = hired > 0 ? hired : DummyHiredCandidates
    }
}
