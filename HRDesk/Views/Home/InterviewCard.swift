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

    @State private var showReschedule = false
    @State private var newDate = Date()
    @State private var newTime = Date()

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .center, spacing: 12) {

                AvatarView(
                    name: interview.candidateName ?? "Candidate",
                    size: 44
                )

                VStack(alignment: .leading, spacing: 3) {

                    Text(interview.candidateName ?? "Candidate")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                        .lineLimit(1)

                    Text(interview.candidateRole ?? "Candidate Role")
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

                    Button {
                        interviewViewModel.markAsDone(interview)
                        if let todo = todoViewModel.todo(
                            withInterviewID: interview.id
                        ) {
                            todoViewModel.setCompletion(
                                todo,
                                isCompleted: true
                            )
                        }
                    } label: {
                        Label("Mark as Done", systemImage: "checkmark.circle")
                    }

                    Button {
                        newDate = interview.date ?? Date()
                        newTime = interview.date ?? Date()
                        showReschedule = true
                    } label: {
                        Label("Re-schedule", systemImage: "calendar.badge.clock")
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

            HStack(spacing: 12) {

                Label(
                    interview.location ?? "Google Meet",
                    systemImage: interview.location == "Walk-in"
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
        .sheet(isPresented: $showReschedule) {

            rescheduleView
        }
    }

    private var rescheduleView: some View {

        VStack(spacing: 20) {

            Text("Re-schedule Interview")
                .font(.headline)
                .foregroundStyle(Color("textPrimary"))

            DatePicker(
                "Date",
                selection: $newDate,
                displayedComponents: .date
            )
            .font(.subheadline)

            DatePicker(
                "Time",
                selection: $newTime,
                displayedComponents: .hourAndMinute
            )
            .font(.subheadline)

            Button {

                let calendar = Calendar.current

                let date = calendar.date(
                    bySettingHour: calendar.component(.hour, from: newTime),
                    minute: calendar.component(.minute, from: newTime),
                    second: 0,
                    of: newDate
                ) ?? newDate

                interviewViewModel.reschedule(
                    interview,
                    to: date
                )

                showReschedule = false

            } label: {

                Text("Save")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(
                        Color("background"),
                        in: RoundedRectangle(cornerRadius: 12)
                    )
            }
        }
        .padding(24)
        .presentationDetents([.medium])
    }
}
