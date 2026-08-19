//
//  AnalyticsViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 18/08/26.
//

import Foundation
import Combine
import CoreData
import SwiftUI

final class AnalyticsViewModel: ObservableObject {

    @Published var candidates: [CandidateEntity] = []
    @Published var jobs: [JobEntity] = []
    @Published var employees: [EmployeeEntity] = []

    private let coreDataService = CoreDataService.shared

    func refresh() {

        candidates = coreDataService.fetchCandidates()
        jobs = coreDataService.fetchJobs()
        employees = coreDataService.fetchEmployees()
    }

    var totalCandidates: Int {
        candidates.count
    }

    var hiredCount: Int {
        pipelineCount(.hired)
    }

    var rejectedCount: Int {
        pipelineCount(.rejected)
    }

    var inProgressCount: Int {
        totalCandidates - hiredCount - rejectedCount
    }

    // MARK: - Pipeline

    func pipelineCount(_ stage: PipelineStage) -> Int {
        candidates.filter { $0.stage == stage }.count
    }

    func countCandidates(for job: JobEntity, stage: PipelineStage) -> Int {
        candidates.filter { $0.job == job && $0.stage == stage }.count
    }

    // MARK: - Conversion

    var appliedToScreening: Int {
        percentage(pipelineCount(.screening), of: pipelineCount(.applied))
    }

    var screeningToInterview: Int {
        percentage(pipelineCount(.interview), of: pipelineCount(.screening))
    }

    var interviewToOffer: Int {
        percentage(pipelineCount(.offer), of: pipelineCount(.interview))
    }

    var offerToHired: Int {
        percentage(pipelineCount(.hired), of: pipelineCount(.offer))
    }

    var appliedToHired: Int {
        percentage(pipelineCount(.hired), of: pipelineCount(.applied))
    }

    // MARK: - Rejections

    struct RejectionSlice: Identifiable {
        let reason: String
        let count: Int
        let color: Color

        var id: String { reason }
    }

    var rejectionSlices: [RejectionSlice] {

        let palette: [Color] = [
            .red, .orange, .pink, .purple,
            .teal, .indigo, .blue, .gray
        ]

        let rejected = candidates.filter { $0.stage == .rejected }
        var grouped: [String: Int] = [:]

        for candidate in rejected {

            let raw = candidate.rejectionReason?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let reason = raw.isEmpty ? "No reason specified" : raw
            grouped[reason, default: 0] += 1
        }

        return grouped.keys.sorted().enumerated().map { index, reason in

            RejectionSlice(
                reason: reason,
                count: grouped[reason] ?? 0,
                color: palette[index % palette.count]
            )
        }
    }

    // MARK: - Jobs

    struct JobRow {
        let job: JobEntity
        let candidates: Int
    }

    var jobRows: [JobRow] {

        jobs
            .map { job in
                JobRow(
                    job: job,
                    candidates: candidates.filter {
                        $0.job == job
                    }.count
                )
            }
            .sorted {
                $0.candidates > $1.candidates
            }
    }

    var topJob: JobRow? {
        jobRows.first
    }

    // MARK: - Team

    var departments: [String] {

        Set(employees.compactMap { $0.department })
            .sorted()
    }

    func employeeCount(in department: String) -> Int {

        employees.filter { $0.department == department }.count
    }

    // MARK: - Chart Data

    struct FunnelStageData: Identifiable {

        let stage: PipelineStage

        var id: PipelineStage { stage }
        var title: String { stage.title }
        var color: Color { stage.color }
        let count: Int
    }

    var funnelStages: [FunnelStageData] {

        PipelineStage.allCases
            .filter { $0 != .rejected }
            .map { stage in
                FunnelStageData(
                    stage: stage,
                    count: pipelineCount(stage)
                )
            }
    }

    struct StageSlice: Identifiable {
        let stage: PipelineStage
        let count: Int

        var id: PipelineStage { stage }
        var color: Color { stage.color }
    }

    var stageSlices: [StageSlice] {

        PipelineStage.allCases.map {
            StageSlice(stage: $0, count: pipelineCount($0))
        }
    }

    struct DepartmentCount: Identifiable {
        let name: String
        let count: Int
        let color: Color

        var id: String { name }
    }

    var departmentCounts: [DepartmentCount] {

        let palette: [Color] = [
            .indigo, .teal, .orange, .pink,
            .blue, .purple, .green, .red
        ]

        return departments.enumerated().map { index, department in

            DepartmentCount(
                name: department,
                count: employeeCount(in: department),
                color: palette[index % palette.count]
            )
        }
    }

    // MARK: - Helpers

    private func percentage(_ count: Int, of total: Int) -> Int {

        guard total > 0 else {
            return 0
        }

        return Int(
            (Double(count) / Double(total)) * 100
        )
    }
}