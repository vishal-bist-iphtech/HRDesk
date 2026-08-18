//
//  CandidateDetailView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI
import PDFKit

struct CandidateDetailView: View {

    let candidate: CandidateEntity

    @EnvironmentObject private var candidateViewModel: CandidateViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTab = CandidateDetailTab.overview
    @State private var showDeleteConfirmation = false

    var body: some View {

        VStack(spacing: 0) {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 24) {

                    candidateHeader

                    detailTabs

                    tabContent
                }
                .padding()
            }

            bottomActions
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItemGroup(
                placement: .topBarTrailing
            ) {

                Button {} label: {

                    Image(systemName: "square.and.arrow.up")
                }

                Button(role: .destructive) {

                    showDeleteConfirmation = true

                } label: {

                    Image(systemName: "trash")
                }
            }
        }
        .confirmationDialog(
            "Delete \(candidate.name)?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {

            Button(
                "Delete",
                role: .destructive
            ) {

                candidateViewModel.deleteCandidate(
                    candidate
                )

                dismiss()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {}
        }
    }

    private var nextStage: PipelineStage? {

        let stages = PipelineStage.allCases

        guard let index = stages.firstIndex(
            of: candidate.stage
        ),
        stages.indices.contains(index + 1) else {
            return nil
        }

        return stages[index + 1]
    }
}

extension CandidateDetailView {

    private var candidateHeader: some View {

        HStack(spacing: 12) {

            AvatarView(
                name: candidate.name,
                size: 76,
                showsMatchBadge: candidate.matchScore >= 80
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(candidate.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color("textPrimary"))

                Text(candidate.role ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {

                    StageBadge(stage: candidate.stage)

                    Text(candidate.appliedDate ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(spacing: 2) {

                ScoreRing(
                    score: candidate.matchScore,
                    size: 62,
                    lineWidth: 4,
                    showsPercent: true
                )
            }
        }
    }
}

extension CandidateDetailView {

    private var detailTabs: some View {

        VStack(spacing: 0) {

            HStack(spacing: 15) {

                ForEach(
                    CandidateDetailTab.allCases,
                    id: \.self
                ) { tab in

                    Button {

                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedTab = tab
                        }

                    } label: {

                        VStack(spacing: 7) {

                            Text(tab.title)
                                .font(
                                    .subheadline.weight(
                                        selectedTab == tab
                                        ? .semibold
                                        : .regular
                                    )
                                )
                                .foregroundStyle(
                                    selectedTab == tab
                                    ? Color("background")
                                    : .secondary
                                )

                            Rectangle()
                                .fill(
                                    selectedTab == tab
                                    ? Color("background")
                                    : Color.clear
                                )
                                .frame(height: 2)
                        }
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                }
            }

            Divider()
        }
    }
}

extension CandidateDetailView {

    @ViewBuilder
    private var tabContent: some View {

        switch selectedTab {

        case .overview:

            overviewContent

        case .experience:

            experienceContent

        case .skills:

            skillsContent

        case .activity:

            resumeContent
        }
    }

    private var overviewContent: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                
                Text("About")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Color("textPrimary").opacity(0.8))

                Text(candidate.about ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()

                detailInfo(
                    icon: "mappin.and.ellipse",
                    text: candidate.location
                )

                detailInfo(
                    icon: "envelope",
                    text: candidate.email
                )

                detailInfo(
                    icon: "phone",
                    text: candidate.phone
                )

                detailInfo(
                    icon: "globe",
                    text: candidate.website
                )

                detailInfo(
                    icon: "briefcase.fill",
                    text: candidate.employmentType
                )

                detailInfo(
                    icon: "clock",
                    text: candidate.noticePeriod
                )

                detailInfo(
                    icon: "indianrupeesign.circle",
                    text: candidate.expectedSalary
                )
            }
        }
    }

    @ViewBuilder
    private func detailInfo(
        icon: String,
        text: String?
    ) -> some View {

        if let text, !text.isEmpty {

            Label(
                text,
                systemImage: icon
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
}

extension CandidateDetailView {

    private var experienceContent: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Experience")
                .font(.title3.weight(.medium))
                .foregroundStyle(Color("textPrimary").opacity(0.8))

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                experienceItem(
                    role: "Product Designer",
                    company: "Airbnb",
                    period: "Jan 2022 – Present · 2 yrs 5 mos"
                )

                experienceItem(
                    role: "Junior Product Designer",
                    company: "Dropbox",
                    period: "Jun 2020 – Dec 2021 · 1 yr 7 mos"
                )
            }
        }
    }

    private func experienceItem(
        role: String,
        company: String,
        period: String
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 12
        ) {

            VStack(spacing: 0) {

                Circle()
                    .fill(
                        Color("background")
                            .opacity(0.5)
                    )
                    .frame(width: 9, height: 9)
                    .padding(.top, 5)

                Rectangle()
                    .fill(
                        Color.gray.opacity(0.18)
                    )
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
            }

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(role)
                    .font(.headline.weight(.medium))
                    .foregroundStyle(Color("textPrimary").opacity(0.8))

                Text(company)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(period)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(
                    "• Designed and shipped new features for the platform.\n• Collaborated with cross-functional teams to improve user experience."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
            }
        }
    }

    private var skillsContent: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Skills")
                .font(.title3.weight(.medium))
                .foregroundStyle(Color("textPrimary").opacity(0.8))

            FlowLayout(
                items: [
                    "Figma",
                    "UI Design",
                    "UX Research",
                    "Prototyping",
                    "Design Systems",
                    "SwiftUI"
                ]
            )
        }
    }

    @ViewBuilder
    private var resumeContent: some View {

        if candidate.resume.isEmpty {

            ContentUnavailableView(
                "No Resume Added",
                systemImage: "doc.text",
                description: Text(
                    "Candidate resume will appear here."
                )
            )
            .padding(.top, 60)

        } else if ResumePreviewView.isPDF(candidate.resume) {

            resumeFrame {
                PDFKitResumeView(
                    resumeData: candidate.resume
                )
            }

        }
        else {

            ContentUnavailableView(
                "Cannot Preview Resume",
                systemImage: "doc.text",
                description: Text(
                    "The attached file format is not supported."
                )
            )
            .padding(.top, 60)
        }
    }

    private func resumeFrame<Content: View>(
        @ViewBuilder content: () -> Content) -> some View {

        content()
            .frame(maxWidth: .infinity)
            .frame(height: 480)
            .overlay {

                RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color.gray.opacity(0.2),
                    lineWidth: 1
                )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
    }
}

extension CandidateDetailView {

    private var hasScheduledInterview: Bool {

        guard let interviews = candidate.interviews as? Set<InterviewEntity> else {
            return false
        }

        return interviews.contains {
            ($0.status ?? "Scheduled") != "Done"
        }
    }

    private var bottomActions: some View {

        HStack(spacing: 10) {

            if hasScheduledInterview {

                NavigationLink {

                    UpcomingInterviewsView()

                } label: {

                    Label(
                        "Interview Scheduled",
                        systemImage: "calendar.badge.checkmark"
                    )
                    .font(
                        .subheadline.weight(.semibold)
                    )
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 46)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .fill(Color("background"))
                    )
                }

            } else {

                Button {

                    guard let nextStage else {
                        return
                    }

                    candidateViewModel.moveToStage(
                        candidate,
                        stage: nextStage
                    )

                } label: {

                    Label(
                        nextStage == nil
                        ? "Move Stage"
                        : "Move to \(nextStage?.title ?? "stage")",
                        systemImage: "arrow.right"
                    )
                    .font(
                        .subheadline.weight(.semibold)
                    )
                    .foregroundStyle(Color("background"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.08))
                        )
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color("background").opacity(0.6),
                            lineWidth: 1.5
                        )
                    }
                }
                .disabled(nextStage == nil)
                .opacity(nextStage == nil ? 0.4 : 1)

                if candidate.stage == .applied || candidate.stage == .screening {

                    NavigationLink {

                        InterviewView(
                            candidate: candidate
                        )

                    } label: {

                        Text("Schedule Interview")
                            .font(
                                .subheadline.weight(.semibold)
                            )
                            .foregroundStyle(.white)
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 46)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 12
                                )
                                .fill(Color("background"))
                            )
                    }
                }
            }
        }
        .padding()
    }
}

extension CandidateDetailView {

    struct FlowLayout: View {

        let items: [String]

        var body: some View {

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 100))
                ],
                alignment: .leading,
                spacing: 4
            ) {

                ForEach(items, id: \.self) { item in

                    Text(item)
                        .font(.headline.weight(.medium))
                        .padding(10)
                        .background(Color("background").opacity(0.08))
                        .foregroundStyle(Color("background"))
                        .clipShape(Capsule())
                }
            }
        }
    }

    enum CandidateDetailTab: CaseIterable {

        case overview
        case experience
        case skills
        case activity

        var title: String {

            switch self {

            case .overview:
                return "Overview"

            case .experience:
                return "Experience"

            case .skills:
                return "Skills"

            case .activity:
                return "Resume"
            }
        }
    }
}

private struct ResumePreviewView {

    static func isPDF(_ data: Data) -> Bool {

        data.prefix(5)
            == Data("%PDF-".utf8)
    }
}

private struct PDFKitResumeView: UIViewRepresentable {

    let resumeData: Data

    func makeUIView(context: Context) -> PDFView {

        let view = PDFView()
        view.document = PDFDocument(data: resumeData)
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.backgroundColor = .systemBackground
        return view
    }

    func updateUIView(
        _ uiView: PDFView,
        context: Context
    ) {

        uiView.document = PDFDocument(data: resumeData)
    }
}
