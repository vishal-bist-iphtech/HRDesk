//
//  ScheduleInterviewView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 14/08/26.
//

import SwiftUI

struct ScheduleInterviewView: View {

    let candidate: CandidateEntity

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var candidateViewModel: CandidateViewModel
    @EnvironmentObject private var todoViewModel: TodoViewModel

    @StateObject private var interviewViewModel = InterviewViewModel()

    @State private var interviewType = "Design Interview"

    @State private var selectedDate = Date()
    @State private var selectedTime = Date()

    @State private var duration = "60 minutes"
    @State private var location = "Google Meet"

    @State private var notes = ""

    @State private var interviewers: [Interviewer] = []

    @State private var showAddInterviewer = false
    @State private var showMissingInterviewerAlert = false
    @State private var showScheduledConfirmation = false

    private var scheduledDate: Date {

        let calendar = Calendar.current

        return calendar.date(
            bySettingHour: calendar.component(.hour, from: selectedTime),
            minute: calendar.component(.minute, from: selectedTime),
            second: 0,
            of: selectedDate
        ) ?? selectedDate
    }

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

            VStack(
                alignment: .leading,
                spacing: 0
            ) {

                CandidateCard(candidate: candidate)

                Divider()
                    .padding(.horizontal, 16)

                InterviewDetailView(
                    interviewType: $interviewType,
                    selectedDate: $selectedDate,
                    selectedTime: $selectedTime,
                    duration: $duration,
                    location: $location,
                    notes: $notes,
                    interviewers: $interviewers,
                    onAddInterviewer: {
                        showAddInterviewer = true
                    }
                )
            }
        }
        .navigationTitle("Schedule Interview")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(
            edge: .bottom
        ) {

            scheduleButton
        }
        .sheet(
            isPresented: $showAddInterviewer
        ) {

            AddInterviewerView { interviewer in

                if !interviewers.contains(where: {
                    $0.employeeID == interviewer.employeeID
                    && $0.name == interviewer.name
                }) {

                    interviewers.append(interviewer)
                }
            }
        }
        .alert(
            "Add an Interviewer",
            isPresented: $showMissingInterviewerAlert
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(
                "Please assign at least one interviewer before scheduling."
            )
        }
        .alert(
            "Interview Scheduled",
            isPresented: $showScheduledConfirmation
        ) {

            Button("Done") {
                dismiss()
            }

        } message: {

            Text(
                "\(interviewType) for \(candidate.name) has been scheduled on \(formattedScheduledDate())."
            )
        }
    }
}

// MARK: - Bottom Button

private extension ScheduleInterviewView {

    var scheduleButton: some View {

        Button {

            guard !interviewers.isEmpty else {
                showMissingInterviewerAlert = true
                return
            }

            let interviewID = interviewViewModel.scheduleInterview(
                candidateID: candidate.id,
                candidateName: candidate.name,
                candidateRole: candidate.role ?? "",
                interviewType: interviewType,
                date: scheduledDate,
                duration: duration,
                location: location,
                notes: notes,
                interviewers: interviewers
            )

            todoViewModel.addTodo(
                title: "Interview: \(candidate.name) – \(interviewType)",
                dueDate: scheduledDate,
                priority: .high,
                interviewID: interviewID
            )

            if candidate.stage != .interview {
                candidateViewModel.moveToStage(
                    candidate,
                    stage: .interview
                )
            }

            showScheduledConfirmation = true

        } label: {

            HStack(spacing: 8) {

                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 15, weight: .semibold))

                Text("Schedule Interview")
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                Color("background"),
                in: RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
            )
            .shadow(
                color: Color.black.opacity(0.15),
                radius: 6,
                x: 0,
                y: 3
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    func formattedScheduledDate() -> String {

        scheduledDate.formatted(
            date: .abbreviated,
            time: .shortened
        )
    }
}
