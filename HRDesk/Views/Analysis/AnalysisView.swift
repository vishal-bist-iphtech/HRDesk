//
//  AnalysisView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 13/08/26.
//

import SwiftUI
import Charts
import CoreData

struct AnalysisView: View {

    @StateObject private var viewModel = AnalyticsViewModel()

    @State private var jobBarSelection: String?

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    header

                    pipelineSection

                    funnelSection

                    conversionSection

                    jobsSection

                    rejectionSection

                    teamSection
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .refreshable {
                viewModel.refresh()
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }

    private var header: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text("Analytics")
                .font(.largeTitle.bold())
                .foregroundStyle(Color("textPrimary"))

            Text("Recruitment performance at a glance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Hiring Pipeline (Donut)

private extension AnalysisView {

    var pipelineSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            VStack(spacing: 14) {

                if viewModel.totalCandidates == 0 {

                    ContentUnavailableView(
                        "No Candidates",
                        systemImage: "person.3"
                    )
                    .padding(.top, 10)

                } else {

                    InteractiveDonutChart(
                        data: viewModel.stageSlices.map {
                            DonutSlice(
                                id: $0.stage.title,
                                label: $0.stage.title,
                                count: $0.count,
                                color: $0.color
                            )
                        },
                        centerTitle: "Total",
                        centerSubtitle: "Candidates"
                    )
                    .frame(height: 240)

                    legend(for: viewModel.stageSlices.map {
                        DonutSlice(
                            id: $0.stage.title,
                            label: $0.stage.title,
                            count: $0.count,
                            color: $0.color
                        )
                    })
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }

    func legend(for slices: [DonutSlice]) -> some View {

        VStack(alignment: .leading, spacing: 8) {

            ForEach(slices) { slice in

                HStack(spacing: 8) {

                    Circle()
                        .fill(slice.color)
                        .frame(width: 9, height: 9)

                    Text(slice.label)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color("textPrimary"))

                    Spacer()

                    Text("\(slice.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Recruitment Funnel

private extension AnalysisView {

    var funnelRows: [FunnelRow] {

        viewModel.jobRows.map { jobRow in

            let stages = PipelineStage.allCases
                .filter { $0 != .rejected }
                .map { stage in
                    FunnelStage(
                        name: stage.title,
                        count: viewModel.countCandidates(
                            for: jobRow.job,
                            stage: stage
                        ),
                        color: stage.color
                    )
                }

            return FunnelRow(
                id: jobRow.job.title ?? "Untitled",
                name: jobRow.job.title ?? "Untitled",
                stages: stages
            )
        }
    }

    var funnelSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Recruitment Funnel",
                subtitle: "How candidates narrow down from applied to hired — per job"
            )

            VStack(spacing: 10) {

                if viewModel.totalCandidates == 0 {

                    ContentUnavailableView(
                        "No Candidates",
                        systemImage: "person.3"
                    )

                } else {

                    RecruitmentFunnelView(funnelData: funnelRows)

                    Text(
                        "\(viewModel.appliedToHired)% of applicants end up hired."
                    )
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}

// MARK: - Conversion Rates

private extension AnalysisView {

    var conversionSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Conversion Rates",
                subtitle: "How candidates progress between stages"
            )

            VStack(spacing: 10) {

                ConversionRow(
                    title: "Applied → Screening",
                    percentage: viewModel.appliedToScreening,
                    tint: .purple
                )

                ConversionRow(
                    title: "Screening → Interview",
                    percentage: viewModel.screeningToInterview,
                    tint: .blue
                )

                ConversionRow(
                    title: "Interview → Offer",
                    percentage: viewModel.interviewToOffer,
                    tint: .teal
                )

                ConversionRow(
                    title: "Offer → Hired",
                    percentage: viewModel.offerToHired,
                    tint: .green
                )
            }
            .padding(16)
            .cardStyle()
        }
    }
}

// MARK: - Applications by Job (Interactive)

private extension AnalysisView {

    var jobsSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Applications by Job",
                subtitle: "Tap a bar or a job below to inspect it"
            )

            VStack(spacing: 12) {

                if viewModel.jobRows.isEmpty {

                    ContentUnavailableView(
                        "No Jobs Posted",
                        systemImage: "briefcase"
                    )
                    .padding(.vertical, 20)

                } else {

                    selectedJobReadout

                    JobBarChart(
                        rows: viewModel.jobRows,
                        accent: Color("background"),
                        selection: $jobBarSelection
                    )
                    .frame(height: 180)

                    jobLegend
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }

    @ViewBuilder
    private var selectedJobReadout: some View {

        if let selection = jobBarSelection,
           let row = viewModel.jobRows.first(where: {
               ($0.job.title ?? "Untitled") == selection
           }) {

            HStack(spacing: 8) {

                Text(row.job.title ?? "Untitled")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary"))
                    .lineLimit(1)

                Spacer()

                Text("\(row.candidates) candidate\(row.candidates == 1 ? "" : "s")")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color("background"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 10))

        } else {

            Text("Tap a bar to see job details")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var jobLegend: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 8) {

                ForEach(viewModel.jobRows, id: \.job.objectID) { row in

                    let name = row.job.title ?? "Untitled"

                    Button {

                        jobBarSelection = jobBarSelection == name ? nil : name

                    } label: {

                        HStack(spacing: 6) {

                            Circle()
                                .fill(Color("background").opacity(0.9))
                                .frame(width: 8, height: 8)

                            Text(name)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Color("textPrimary"))
                                .lineLimit(1)

                            Text("\(row.candidates)")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            jobBarSelection == name
                            ? Color("background").opacity(0.18)
                            : Color.gray.opacity(0.06)
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Offer Rejection Reasons (Pie)

private extension AnalysisView {

    private var rejectionSlices: [DonutSlice] {

        viewModel.rejectionSlices.map {
            DonutSlice(
                id: $0.reason,
                label: $0.reason,
                count: $0.count,
                color: $0.color
            )
        }
    }

    var rejectionSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Offer Rejection Reasons",
                subtitle: "Why offers or candidates fell through — tap a slice"
            )

            VStack(spacing: 14) {

                if rejectionSlices.isEmpty {

                    ContentUnavailableView(
                        "No Rejections Yet",
                        systemImage: "hand.thumbsdown"
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: rejectionSlices,
                        centerTitle: "Total",
                        centerSubtitle: "Rejected",
                        innerRadiusRatio: 0,
                        showsCenterLabel: false
                    )
                    .frame(height: 220)

                    legend(for: rejectionSlices)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}

// MARK: - Team by Department (Pie)

private extension AnalysisView {

    private var teamSlices: [DonutSlice] {

        viewModel.departmentCounts.map {
            DonutSlice(
                id: $0.name,
                label: $0.name,
                count: $0.count,
                color: $0.color
            )
        }
    }

    var teamSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Team by Department",
                subtitle: "Employee distribution across teams — tap a slice"
            )

            VStack(spacing: 14) {

                if teamSlices.isEmpty {

                    ContentUnavailableView(
                        "No Employees Yet",
                        systemImage: "person.3"
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: teamSlices,
                        centerTitle: "Total",
                        centerSubtitle: "Employees",
                        innerRadiusRatio: 0,
                        showsCenterLabel: false
                    )
                    .frame(height: 240)

                    legend(for: teamSlices)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}

// MARK: - Shared Helpers

private extension AnalysisView {

    func sectionHeader(
        title: String,
        subtitle: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 3) {

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color("textPrimary"))

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Interactive Donut / Pie Chart

struct DonutSlice: Identifiable {
    let id: String
    let label: String
    let count: Int
    let color: Color
}

struct InteractiveDonutChart: View {

    let data: [DonutSlice]
    let centerTitle: String
    let centerSubtitle: String
    var innerRadiusRatio: Double = 0.62
    var showsCenterLabel: Bool = true

    @State private var selectedID: String?

    private var total: Int {
        data.reduce(0) { $0 + $1.count }
    }

    private var selected: DonutSlice? {
        guard let selectedID else { return nil }
        return data.first { $0.id == selectedID }
    }

    var body: some View {

        Chart(data) { slice in

            SectorMark(
                angle: .value("Count", slice.count),
                innerRadius: .ratio(innerRadiusRatio),
                angularInset: 1.5
            )
            .cornerRadius(5)
            .foregroundStyle(slice.color)
            .opacity(selected == nil || selected?.id == slice.id ? 1 : 0.35)
        }
        .chartBackground { proxy in

            if showsCenterLabel, total > 0 {

                GeometryReader { geo in

                    if let plotFrame = proxy.plotFrame {

                        let frame = geo[plotFrame]

                        VStack(spacing: 2) {

                            Text(selected?.label ?? centerTitle)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)

                            Text(
                                selected.map { "\($0.count)" } ?? "\(total)"
                            )
                            .font(.title2.bold())
                            .foregroundStyle(Color("textPrimary"))

                            if selected != nil {

                                Text(
                                    "\(Int(Double(selected!.count) / Double(total) * 100))%"
                                )
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color("background"))
                            }
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
        }
        .chartOverlay { proxy in

            GeometryReader { geo in

                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture().onEnded { value in
                            selectSlice(
                                at: value.location,
                                in: geo,
                                proxy: proxy
                            )
                        }
                    )
            }
        }
    }

    private func selectSlice(
        at location: CGPoint,
        in geo: GeometryProxy,
        proxy: ChartProxy
    ) {

        guard total > 0,
              let plotFrame = proxy.plotFrame
        else {
            return
        }

        let frame = geo[plotFrame]
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let dx = location.x - center.x
        let dy = location.y - center.y
        let radius = sqrt(dx * dx + dy * dy)
        let outerRadius = min(frame.width, frame.height) / 2
        let innerRadius = outerRadius * innerRadiusRatio

        guard radius >= innerRadius, radius <= outerRadius else {
            selectedID = nil
            return
        }

        var angle = atan2(dy, dx) * 180 / .pi + 90

        if angle < 0 {
            angle += 360
        } else if angle >= 360 {
            angle -= 360
        }

        var cumulative = 0.0

        for slice in data {

            cumulative += Double(slice.count) / Double(total) * 360

            if angle < cumulative {
                selectedID = slice.id
                return
            }
        }

        selectedID = nil
    }
}

// MARK: - Recruitment Funnel (matrix per job)

struct FunnelStage: Identifiable {
    let name: String
    let count: Int
    let color: Color

    var id: String { name }
}

struct FunnelRow: Identifiable {
    let id: String
    let name: String
    let stages: [FunnelStage]
}

struct FunnelCell: View {

    let name: String
    let count: Int
    let color: Color
    let normalizedHeight: CGFloat

    var body: some View {

        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        color.opacity(0.30 + 0.55 * normalizedHeight),
                        color.opacity(0.20)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: max(16, 44 * normalizedHeight))
            .overlay {

                if count > 0 {

                    Text("\(count)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                }
            }
            .accessibilityLabel("\(name): \(count)")
    }
}

struct RecruitmentFunnelView: View {

    let funnelData: [FunnelRow]

    private var stageColumns: [String] {

        funnelData.first?.stages.map(\.name)
            ?? PipelineStage.allCases
                .filter { $0 != .rejected }
                .map(\.title)
    }

    private func maxCount(in row: FunnelRow) -> Int {

        row.stages.map(\.count).max() ?? 1
    }

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            VStack(alignment: .leading, spacing: 10) {

                HStack(spacing: 8) {

                    Color.clear
                        .frame(width: 110)

                    HStack(spacing: 4) {

                        ForEach(stageColumns, id: \.self) { name in

                            Text(name)
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }

                ForEach(funnelData) { row in

                    HStack(spacing: 8) {

                        Text(row.name)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Color("textPrimary"))
                            .lineLimit(2)
                            .frame(width: 110, alignment: .leading)

                        HStack(spacing: 4) {

                            ForEach(row.stages) { stage in

                                FunnelCell(
                                    name: stage.name,
                                    count: stage.count,
                                    color: stage.color,
                                    normalizedHeight: CGFloat(stage.count)
                                        / CGFloat(maxCount(in: row))
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct FunnelMatrixView: View {

    let funnelData: [FunnelRow]

    private var stageColumns: [String] {

        funnelData.first?.stages.map(\.name)
            ?? PipelineStage.allCases
                .filter { $0 != .rejected }
                .map(\.title)
    }

    var body: some View {

        Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 8) {

            GridRow {

                Text("Job")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)

                ForEach(stageColumns, id: \.self) { name in

                    Text(name)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            ForEach(funnelData) { row in

                GridRow {

                    Text(row.name)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Color("textPrimary"))
                        .lineLimit(2)

                    ForEach(row.stages) { stage in

                        let ratio = row.stages.map(\.count).max() ?? 1

                        Text(stage.count > 0 ? "\(stage.count)" : "–")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Color("textPrimary"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(
                                stage.color.opacity(stage.count > 0
                                    ? 0.15 + 0.5 * Double(stage.count) / Double(ratio)
                                    : 0.05)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }
}

// MARK: - Job Bar Chart (Interactive)

struct JobBarChart: View {

    let rows: [AnalyticsViewModel.JobRow]
    let accent: Color

    @Binding var selection: String?

    var body: some View {

        Chart {

            ForEach(rows, id: \.job.objectID) { row in

                let name = row.job.title ?? "Untitled"

                BarMark(
                    x: .value("Job", name),
                    y: .value("Candidates", row.candidates)
                )
                .foregroundStyle(
                    selection == nil || selection == name
                    ? accent.opacity(0.85)
                    : accent.opacity(0.20)
                )
                .cornerRadius(5)
                .annotation(position: .top) {

                    if selection == name {

                        Text("\(row.candidates)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(Color("textPrimary"))
                    }
                }
            }
        }
        .chartXSelection(value: $selection)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks {
                AxisGridLine()
                    .foregroundStyle(Color.gray.opacity(0.15))
                AxisValueLabel()
                    .font(.caption2)
            }
        }
        .animation(.snappy, value: selection)
    }
}

// MARK: - Conversion Row

struct ConversionRow: View {

    let title: String
    let percentage: Int
    let tint: Color

    var body: some View {

        HStack(spacing: 12) {

            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color("textPrimary"))

            Spacer()

            Text("\(percentage)%")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(Color.gray.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Safe Subscript

extension Array {

    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Card Style

private extension View {

    func cardStyle() -> some View {

        self
            .background(Color.gray.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {

                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.10), lineWidth: 1)
            }
    }
}