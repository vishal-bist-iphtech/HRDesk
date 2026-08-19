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

    @StateObject private var analyticsViewModel = AnalyticsViewModel()

    @State private var jobBarSelection: String?

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 20) {

                    header

                    kpiSection

                    funnelSection

                    conversionSection

                    candidateDistributionSection

                    jobsSection

                    departmentSection

                    rejectionSection
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .refreshable {
                analyticsViewModel.refresh()
            }
        }
        .onAppear {
            analyticsViewModel.refresh()
        }
    }

    // MARK: - Header

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


// MARK: - KPI Cards

private extension AnalysisView {

    var kpiItems: [
        (
            icon: String,
            title: String,
            value: String,
            tint: Color
        )
    ] {

        [
            (
                icon: "person.3.fill",
                title: "Candidates",
                value: "\(analyticsViewModel.totalCandidates)",
                tint: .purple
            ),

            (
                icon: "checkmark.circle.fill",
                title: "Hired",
                value: "\(analyticsViewModel.hiredCount)",
                tint: .green
            ),

            (
                icon: "hourglass.circle.fill",
                title: "In Progress",
                value: "\(analyticsViewModel.inProgressCount)",
                tint: .orange
            ),

            (
                icon: "arrow.up.right.circle.fill",
                title: "Conversion",
                value: "\(analyticsViewModel.appliedToHired)%",
                tint: Color("background")
            )
        ]
    }


    var kpiSection: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {

            ForEach(kpiItems, id: \.title) { item in

                StatCard(
                    icon: item.icon,
                    title: item.title,
                    value: item.value,
                    tint: item.tint
                )
            }
        }
    }
}


// MARK: - Recruitment Funnel

private extension AnalysisView {

    var funnelSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Recruitment Funnel",
                subtitle: "Candidate progression from application to hiring"
            )

            VStack(spacing: 14) {

                if analyticsViewModel.totalCandidates == 0 {

                    ContentUnavailableView(
                        "No Candidates",
                        systemImage: "person.3",
                        description: Text(
                            "Candidate data will appear here once applications are added."
                        )
                    )
                    .padding(.vertical, 10)

                } else {

                    RecruitmentFunnelChart(
                        stages: analyticsViewModel.funnelStages
                    )

                    HStack {

                        Text("Overall conversion")

                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(analyticsViewModel.appliedToHired)%")

                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Color("background"))
                    }
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
                title: "Stage Conversion",
                subtitle: "Percentage of candidates moving to the next stage"
            )

            VStack(spacing: 12) {

                if analyticsViewModel.totalCandidates == 0 {

                    ContentUnavailableView(
                        "No Conversion Data",
                        systemImage: "chart.bar.xaxis"
                    )
                    .padding(.vertical, 10)

                } else {

                    ConversionChart(
                        appliedToScreening: analyticsViewModel.appliedToScreening,
                        screeningToInterview: analyticsViewModel.screeningToInterview,
                        interviewToOffer: analyticsViewModel.interviewToOffer,
                        offerToHired: analyticsViewModel.offerToHired
                    )
                    .frame(height: 230)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}


// MARK: - Candidate Distribution

private extension AnalysisView {

    private var candidateDistributionSlices: [DonutSlice] {

        [
            DonutSlice(
                id: "In Progress",
                label: "In Progress",
                count: analyticsViewModel.inProgressCount,
                color: .orange
            ),

            DonutSlice(
                id: "Hired",
                label: "Hired",
                count: analyticsViewModel.hiredCount,
                color: .green
            ),

            DonutSlice(
                id: "Rejected",
                label: "Rejected",
                count: analyticsViewModel.rejectedCount,
                color: .red
            )
        ]
        .filter {
            $0.count > 0
        }
    }


    var candidateDistributionSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Candidate Distribution",
                subtitle: "Current recruitment status across all candidates"
            )

            VStack(spacing: 14) {

                if candidateDistributionSlices.isEmpty {

                    ContentUnavailableView(
                        "No Candidates",
                        systemImage: "person.3"
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: candidateDistributionSlices,
                        centerTitle: "Candidates",
                        centerSubtitle: "",
                        centerValue: "\(analyticsViewModel.totalCandidates)",
                        innerRadiusRatio: 0.64
                    )
                    .frame(height: 230)

                    legend(
                        for: candidateDistributionSlices
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}


// MARK: - Applications by Job

private extension AnalysisView {

    var jobsSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Applications by Job",
                subtitle: "Number of candidates applying for each position"
            )

            VStack(spacing: 14) {

                if analyticsViewModel.jobRows.isEmpty {

                    ContentUnavailableView(
                        "No Jobs Posted",
                        systemImage: "briefcase",
                        description: Text(
                            "Post a job to start receiving applications."
                        )
                    )
                    .padding(.vertical, 20)

                } else {

                    selectedJobReadout

                    JobBarChart(
                        rows: analyticsViewModel.jobRows,
                        accent: Color("background"),
                        selection: $jobBarSelection
                    )
                    .frame(
                        height: max(
                            180,
                            CGFloat(analyticsViewModel.jobRows.count) * 45
                        )
                    )
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
           let row = analyticsViewModel.jobRows.first(
                where: {
                    ($0.job.title ?? "Untitled") == selection
                }
           ) {

            HStack(spacing: 8) {

                Image(systemName: "briefcase.fill")
                    .font(.caption)
                    .foregroundStyle(Color("background"))

                Text(row.job.title ?? "Untitled")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary"))
                    .lineLimit(1)

                Spacer()

                Text(
                    "\(row.candidates) candidate\(row.candidates == 1 ? "" : "s")"
                )
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color("background"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                Color("background").opacity(0.06)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )

        } else {

            Text("Tap a bar to see job details")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
    }
}


// MARK: - Department Wise Hiring

private extension AnalysisView {

    private var departmentSlices: [DonutSlice] {

        analyticsViewModel.departmentCounts.map {

            DonutSlice(
                id: $0.name,
                label: $0.name,
                count: $0.count,
                color: $0.color
            )
        }
    }


    var departmentSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionHeader(
                title: "Department-Wise Hiring",
                subtitle: "Hired employees distributed across departments"
            )

            VStack(spacing: 14) {

                if departmentSlices.isEmpty {

                    ContentUnavailableView(
                        "No Hiring Data",
                        systemImage: "person.3",
                        description: Text(
                            "Department hiring data will appear after employees are added."
                        )
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: departmentSlices,
                        centerTitle: "Total",
                        centerSubtitle: "Hired",
                        innerRadiusRatio: 0.64
                    )
                    .frame(height: 230)

                    legend(
                        for: departmentSlices
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}


// MARK: - Rejection Reasons

private extension AnalysisView {

    private var rejectionSlices: [DonutSlice] {

        analyticsViewModel.rejectionSlices.map {

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
                title: "Rejection Reasons",
                subtitle: "Why candidates or offers were rejected"
            )

            VStack(spacing: 14) {

                if rejectionSlices.isEmpty {

                    ContentUnavailableView(
                        "No Rejections Yet",
                        systemImage: "hand.thumbsdown",
                        description: Text(
                            "Rejection data will appear as candidates are rejected."
                        )
                    )
                    .padding(.vertical, 10)

                } else {

                    InteractiveDonutChart(
                        data: rejectionSlices,
                        centerTitle: "Total",
                        centerSubtitle: "Rejected",
                        innerRadiusRatio: 0.64
                    )
                    .frame(height: 230)

                    legend(
                        for: rejectionSlices
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .cardStyle()
        }
    }
}


// MARK: - Legend

private extension AnalysisView {

    func legend(
        for slices: [DonutSlice]
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            ForEach(slices) { slice in

                HStack(spacing: 8) {

                    Circle()
                        .fill(slice.color)
                        .frame(
                            width: 9,
                            height: 9
                        )

                    Text(slice.label)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(
                            Color("textPrimary")
                        )

                    Spacer()

                    Text("\(slice.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}


// MARK: - Section Header

private extension AnalysisView {

    func sectionHeader(
        title: String,
        subtitle: String
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 3
        ) {

            Text(title)
                .font(
                    .title3.weight(.semibold)
                )
                .foregroundStyle(
                    Color("textPrimary")
                )

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}


// MARK: - Recruitment Funnel Chart

private struct RecruitmentFunnelChart: View {

    let stages: [
        AnalyticsViewModel.FunnelStageData
    ]

    private var maxCount: Int {

        stages
            .map(\.count)
            .max() ?? 1
    }

    var body: some View {

        VStack(spacing: 12) {

            ForEach(
                stages,
                id: \.id
            ) { stage in

                HStack(spacing: 12) {

                    Text(stage.title)
                        .font(
                            .caption.weight(.medium)
                        )
                        .foregroundStyle(
                            Color("textPrimary")
                        )
                        .frame(
                            width: 80,
                            alignment: .leading
                        )

                    GeometryReader { geometry in

                        ZStack(alignment: .leading) {

                            Capsule()
                                .fill(
                                    Color.gray.opacity(0.10)
                                )

                            Capsule()
                                .fill(stage.color)
                                .frame(
                                    width:
                                        geometry.size.width
                                        * CGFloat(stage.count)
                                        / CGFloat(maxCount)
                                )
                        }
                    }
                    .frame(height: 18)

                    Text("\(stage.count)")
                        .font(
                            .caption.weight(.bold)
                        )
                        .foregroundStyle(
                            stage.color
                        )
                        .frame(
                            width: 35,
                            alignment: .trailing
                        )
                }
                .frame(height: 22)
            }
        }
    }
}


// MARK: - Conversion Chart

private struct ConversionChart: View {

    let appliedToScreening: Int
    let screeningToInterview: Int
    let interviewToOffer: Int
    let offerToHired: Int

    private var data: [
        ConversionData
    ] {

        [
            ConversionData(
                stage: "Applied → Screening",
                percentage: appliedToScreening
            ),

            ConversionData(
                stage: "Screening → Interview",
                percentage: screeningToInterview
            ),

            ConversionData(
                stage: "Interview → Offer",
                percentage: interviewToOffer
            ),

            ConversionData(
                stage: "Offer → Hired",
                percentage: offerToHired
            )
        ]
    }

    var body: some View {

        Chart(data) { item in

            BarMark(
                x: .value(
                    "Conversion",
                    item.percentage
                ),
                y: .value(
                    "Stage",
                    item.stage
                )
            )
            .foregroundStyle(
                Color("background").opacity(0.85)
            )
            .cornerRadius(5)

            BarMark(
                x: .value(
                    "Conversion",
                    item.percentage
                ),
                y: .value(
                    "Stage",
                    item.stage
                )
            )
            .annotation(
                position: .trailing
            ) {

                Text("\(item.percentage)%")
                    .font(
                        .caption2.weight(.bold)
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )
            }
        }
        .chartXScale(
            domain: 0...100
        )
        .chartXAxis {

            AxisMarks(
                values: [0, 25, 50, 75, 100]
            ) { value in

                AxisGridLine()
                    .foregroundStyle(
                        Color.gray.opacity(0.12)
                    )

                AxisValueLabel {
                    if let percentage = value.as(Int.self) {

                        Text("\(percentage)%")
                            .font(.caption2)
                    }
                }
            }
        }
        .chartYAxis {

            AxisMarks { value in

                AxisValueLabel {
                    if let stage = value.as(String.self) {

                        Text(stage)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}

private struct ConversionData: Identifiable {

    let id = UUID()

    let stage: String

    let percentage: Int
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

    var centerValue: String? = nil

    var innerRadiusRatio: Double = 0.62

    var showsCenterLabel: Bool = true

    @State private var selectedID: String?

    private var total: Int {

        data.reduce(0) {
            $0 + $1.count
        }
    }

    private var selected: DonutSlice? {

        guard let selectedID else {
            return nil
        }

        return data.first {
            $0.id == selectedID
        }
    }

    var body: some View {

        Chart(data) { slice in

            SectorMark(
                angle: .value(
                    "Count",
                    slice.count
                ),
                innerRadius: .ratio(
                    innerRadiusRatio
                ),
                angularInset: 0.5
            )
            .cornerRadius(5)
            .foregroundStyle(
                slice.color
            )
            .opacity(
                selected == nil ||
                selected?.id == slice.id
                ? 1
                : 0.35
            )
        }
        .chartBackground { proxy in

            if showsCenterLabel,
               total > 0 {

                GeometryReader { geo in

                    if let plotFrame =
                        proxy.plotFrame {

                        let frame =
                            geo[plotFrame]

                        VStack(spacing: 2) {

                            Text(
                                selected?.label ??
                                centerTitle
                            )
                            .font(
                                .subheadline.weight(
                                    .semibold
                                )
                            )
                            .foregroundStyle(
                                .secondary
                            )
                            .lineLimit(1)

                            Text(
                                selected.map {
                                    "\($0.count)"
                                }
                                ?? (
                                    centerValue
                                    ?? "\(total)"
                                )
                            )
                            .font(
                                .title2.bold()
                            )
                            .foregroundStyle(
                                Color("textPrimary")
                            )

                            if selected != nil {

                                Text("\(Int(Double(selected!.count) / Double(total) * 100))%")
                                .font(
                                    .caption.weight(
                                        .semibold
                                    )
                                )
                                .foregroundStyle(
                                    Color("background")
                                )
                            }
                        }
                        .position(
                            x: frame.midX,
                            y: frame.midY
                        )
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
                        SpatialTapGesture()
                            .onEnded { value in

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

        let center = CGPoint(
            x: frame.midX,
            y: frame.midY
        )

        let dx =
            location.x - center.x

        let dy =
            location.y - center.y

        let radius =
            sqrt(
                dx * dx +
                dy * dy
            )

        let outerRadius =
            min(
                frame.width,
                frame.height
            ) / 2

        let innerRadius =
            outerRadius *
            innerRadiusRatio

        guard radius >= innerRadius,
              radius <= outerRadius
        else {

            selectedID = nil

            return
        }

        var angle =
            atan2(dy, dx)
            * 180
            / .pi
            + 90

        if angle < 0 {

            angle += 360

        } else if angle >= 360 {

            angle -= 360
        }

        var cumulative = 0.0

        for slice in data {

            cumulative +=
                Double(slice.count)
                / Double(total)
                * 360

            if angle < cumulative {

                selectedID = slice.id

                return
            }
        }

        selectedID = nil
    }
}


// MARK: - Job Bar Chart

struct JobBarChart: View {

    let rows: [
        AnalyticsViewModel.JobRow
    ]

    let accent: Color

    @Binding var selection: String?

    var body: some View {

        Chart {

            ForEach(
                rows,
                id: \.job.objectID
            ) { row in

                let name =
                    row.job.title ??
                    "Untitled"

                BarMark(
                    x: .value(
                        "Candidates",
                        row.candidates
                    ),
                    y: .value(
                        "Job",
                        name
                    )
                )
                .foregroundStyle(
                    selection == nil ||
                    selection == name
                    ? accent.opacity(0.85)
                    : accent.opacity(0.20)
                )
                .cornerRadius(5)
                .annotation(
                    position: .trailing
                ) {

                    Text("\(row.candidates)")
                        .font(
                            .caption2.weight(.bold)
                        )
                        .foregroundStyle(
                            Color("textPrimary")
                        )
                }
            }
        }
        .chartYSelection(
            value: $selection
        )
        .chartXAxis {

            AxisMarks { value in

                AxisGridLine()
                    .foregroundStyle(
                        Color.gray.opacity(0.12)
                    )

                AxisValueLabel()
                    .font(.caption2)
            }
        }
        .chartYAxis {

            AxisMarks { value in

                AxisValueLabel {
                    if let name =
                        value.as(String.self) {

                        Text(name)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
        }
        .animation(
            .snappy,
            value: selection
        )
    }
}


// MARK: - Preview

#Preview {

    AnalysisView()
}
