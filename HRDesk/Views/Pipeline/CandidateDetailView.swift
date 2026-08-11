//
//  CandidateDetailView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct CandidateDetailView: View {

    let candidate: Candidate

    @State private var selectedTab = CandidateDetailTab.overview

    var body: some View {

        VStack(spacing: 0) {

            ScrollView(
                showsIndicators: false
            ) {

                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {

                    candidateHeader

                    detailTabs

                    tabContent
                }
                .padding()
            }

            bottomActions
        }
        .background(
            Color("background")
                .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItemGroup(
                placement: .topBarTrailing
            ) {

                Button {} label: {

                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

extension CandidateDetailView {

    private var candidateHeader: some View {

        HStack(spacing: 12) {

            AvatarView(
                candidate: candidate,
                size: 76,
                showFavoriteBadge: true
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(candidate.name)
                    .font(
                        .headline.weight(.bold)
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Text(candidate.role)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {

                    StageBadge(stage: candidate.stage)

                    Text(candidate.appliedDate)
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
                                    ? Color("textSecondary")
                                    : .secondary
                                )

                            Rectangle()
                                .fill(
                                    selectedTab == tab
                                    ? Color("textSecondary")
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

            activityContent
        }
    }

    private var overviewContent: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text("About")
                    .font(.headline)
                    .foregroundStyle(Color("textPrimary"))

                Text(candidate.about)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(
                alignment: .leading,
                spacing: 12
            ) {

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
                    icon: "link",
                    text: "LinkedIn Profile"
                )
            }
        }
    }

    private func detailInfo(
        icon: String,
        text: String
    ) -> some View {

        Label(
            text,
            systemImage: icon
        )
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
}

extension CandidateDetailView {

    private var experienceContent: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Experience")
                .font(.headline)
                .foregroundStyle(
                    Color("textPrimary")
                )

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
                        Color("textSecondary")
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
                    .font(
                        .subheadline.weight(.semibold)
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Text(company)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(period)
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(
                    "• Designed and shipped new features for the platform.\n• Collaborated with cross-functional teams to improve user experience."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
            }
        }
    }

    private var skillsContent: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Skills")
                .font(.headline)

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

    private var activityContent: some View {

        ContentUnavailableView(
            "No Recent Activity",
            systemImage: "clock",
            description: Text(
                "Candidate activity will appear here."
            )
        )
    }
}

extension CandidateDetailView {

    private var bottomActions: some View {

        HStack(spacing: 10) {

            Button {

                // Move candidate to next stage

            } label: {

                Label(
                    "Move Stage",
                    systemImage: "arrow.right"
                )
                .font(
                    .subheadline.weight(.semibold)
                )
                .foregroundStyle(
                    Color("textSecondary")
                )
                .frame(
                    maxWidth: .infinity
                )
                .frame(height: 46)
                .background(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .fill(Color.gray.opacity(0.08))
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .stroke(
                        Color("textSecondary")
                            .opacity(0.6),
                        lineWidth: 1.5
                    )
                }
            }

            Button {

                // Schedule interview

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
                        .fill(Color("textSecondary"))
                    )
            }
        }
        .padding()
        .background(
            Color("background")
        )
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
                spacing: 8
            ) {

                ForEach(items, id: \.self) { item in

                    Text(item)
                        .font(.caption2.weight(.medium))
                        .padding(
                            .horizontal,
                            10
                        )
                        .padding(
                            .vertical,
                            6
                        )
                        .background(
                            Color("textSecondary")
                                .opacity(0.08)
                        )
                        .foregroundStyle(
                            Color("textSecondary")
                        )
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
