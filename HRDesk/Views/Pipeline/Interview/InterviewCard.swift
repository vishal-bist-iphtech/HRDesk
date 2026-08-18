//
//  InterviewCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI
import CoreData

struct InterviewCard: View {

    let interview: InterviewEntity

    @EnvironmentObject private var interviewViewModel: InterviewViewModel
    @EnvironmentObject private var todoViewModel: TodoViewModel
    @EnvironmentObject private var candidateViewModel: CandidateViewModel

    @State private var showEdit = false

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .center, spacing: 12) {

                AvatarView(
                    name: interview.candidate?.fullName ?? "Candidate",
                    size: 44
                )

                VStack(alignment: .leading, spacing: 3) {

                    Text(interview.candidate?.fullName ?? "Candidate")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                        .lineLimit(1)

                    Text(interview.candidate?.role ?? "Candidate Role")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 3) {

                    Text(
                        (interview.date ?? Date())
                            .formatted(date: .abbreviated, time: .shortened)
                    )
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color("background"))

                    Text(interview.interviewType ?? "Interview")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Menu {

                    Menu {

                        ForEach(
                            [PipelineStage.offer, .rejected],
                            id: \.self
                        ) { stage in

                            Button {

                                if let candidate = interview.candidate {
                                    candidateViewModel.moveToStage(
                                        candidate,
                                        stage: stage
                                    )
                                }

                                interviewViewModel.moveToStatus(
                                    interview,
                                    status: "Done"
                                )

                            } label: {

                                if interview.candidate?.stage == stage {
                                    Label(
                                        stage.title,
                                        systemImage: "checkmark"
                                    )
                                } else {
                                    Text(stage.title)
                                }
                            }
                        }

                    } label: {

                        Label(
                            "Move to",
                            systemImage: "arrow.right"
                        )
                    }

                    Button {
                        showEdit = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        interviewViewModel.deleteInterview(interview)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                } label: {

                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                        .frame(width: 26, height: 26)
                        .contentShape(
                            RoundedRectangle(cornerRadius: 6)
                        )
                }
            }

            Divider()

            if let interviewers = interview.interviewer as? Set<EmployeeEntity>,
               !interviewers.isEmpty {

                let names = interviewers
                    .sorted {
                        ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "")
                            == .orderedAscending
                    }
                    .compactMap { $0.name }
                    .joined(separator: ", ")

                Label(names, systemImage: "person.2.fill")
                    .lineLimit(1)

                Divider()
            }

            HStack(spacing: 12) {

                Label(
                    interview.location ?? "Google Meet",
                    systemImage: interview.location == "In-Office"
                    ? "figure.walk"
                    : "video.fill"
                )

                Label(
                    interview.duration ?? "60 minutes",
                    systemImage: "timer"
                )

                Spacer(minLength: 0)

                Label(
                    interview.status ?? "Scheduled",
                    systemImage: "calendar"
                )
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(.white))
        .overlay {

            RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray.opacity(0.15))
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .sheet(isPresented: $showEdit) {

            EditInterviewView(
                interview: interview
            )
        }
    }
}


//#Preview {
//    let context = PersistenceController.preview.container.viewContext
//
//    let candidate = CandidateEntity(context: context)
//    candidate.id = UUID()
//    candidate.fullName = "Vishal Bisht"
//    candidate.role = "iOS Developer"
//
//    let interview = InterviewEntity(context: context)
//    interview.id = UUID()
//    interview.date = Date()
//    interview.candidate = candidate
//    interview.location = "Google Meet"
//    interview.duration = "60 minutes"
//    interview.interviewType = "Technical Interview"
//    interview.status = "Scheduled"
//
//    return InterviewCard(interview: interview)
//        .environmentObject(InterviewViewModel())
//        .environmentObject(TodoViewModel())
//        .environmentObject(CandidateViewModel())
//}
