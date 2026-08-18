//
//  EditInterviewView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 18/08/26.
//

import SwiftUI
import CoreData

struct EditInterviewView: View {

    let interview: InterviewEntity

    @EnvironmentObject private var interviewViewModel: InterviewViewModel
    @EnvironmentObject private var todoViewModel: TodoViewModel
    @Environment(\.dismiss) private var dismiss

    private let interviewTypes = [
        "Design Interview",
        "Technical Interview",
        "HR Interview",
        "Managerial Interview"
    ]

    private let durations = [
        "30 minutes",
        "45 minutes",
        "60 minutes",
        "90 minutes"
    ]

    @State private var interviewType = "Technical Interview"
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var duration = "60 minutes"
    @State private var location = "Google Meet"
    @State private var notes = ""
    @State private var interviewers: [Interviewer] = []

    @State private var showAddInterviewer = false
    @State private var showMissingInterviewerAlert = false

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

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 0) {

                    typeSection

                    interviewersSection

                    dateSection

                    durationSection

                    locationSection

                    notesSection
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Edit Interview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Save") {
                        save()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showAddInterviewer) {

                AddInterviewerView { interviewer in

                    if !interviewers.contains(where: {
                        $0.employeeID != nil
                        && $0.employeeID == interviewer.employeeID
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
                    "Please assign at least one interviewer before saving."
                )
            }
            .onAppear(perform: populate)
        }
    }

    private func populate() {

        interviewType = interview.interviewType ?? interviewType
        selectedDate = interview.date ?? Date()
        selectedTime = interview.date ?? Date()
        duration = interview.duration ?? duration
        location = interview.location ?? location
        notes = interview.notes ?? ""

        interviewers = (interview.interviewer as? Set<EmployeeEntity> ?? [])
            .map {
                Interviewer(
                    name: $0.name ?? "",
                    role: $0.position ?? "",
                    employeeID: $0.id
                )
            }
    }

    private func save() {

        guard !interviewers.isEmpty else {
            showMissingInterviewerAlert = true
            return
        }

        interviewViewModel.updateInterview(
            interview,
            interviewType: interviewType,
            date: scheduledDate,
            duration: duration,
            location: location,
            notes: notes,
            interviewerIDs: interviewers.compactMap { $0.employeeID }
        )

        if let todo = todoViewModel.todo(
            withInterviewID: interview.id
        ) {

            todoViewModel.updateTodo(
                todo,
                title: todo.title ?? "",
                dueDate: scheduledDate,
                priority: TodoItem.Priority(
                    rawValue: todo.priority ?? "Medium"
                ) ?? .medium
            )
        }

        dismiss()
    }
}

// MARK: - Sections

private extension EditInterviewView {

    var typeSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Interview Type")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("textPrimary").opacity(0.7))

            Menu {

                ForEach(interviewTypes, id: \.self) { type in

                    Button(type) {
                        interviewType = type
                    }
                }

            } label: {

                HStack(spacing: 10) {

                    Image(systemName: "laptopcomputer")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color("background"))
                        .frame(width: 18)

                    Text(interviewType)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color("textPrimary"))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .frame(minHeight: 46)
                .background(Color(.systemGray6).opacity(0.6))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    var interviewersSection: some View {

        VStack(alignment: .leading, spacing: 9) {

            Text("Interviewers")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("textPrimary").opacity(0.7))

            VStack(spacing: 8) {

                ForEach(interviewers) { person in

                    InterviewerRow(
                        person: person,
                        onRemove: {
                            interviewers.removeAll {
                                $0.id == person.id
                            }
                        }
                    )
                }

                Button {
                    showAddInterviewer = true
                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "person.badge.plus")
                            .font(.subheadline)
                            .foregroundStyle(Color("background"))
                            .frame(width: 18)

                        Text("Add Interviewer")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color("textPrimary"))
                    }
                    .padding(.horizontal, 12)
                    .frame(minHeight: 46)
                    .background(Color(.systemGray6).opacity(0.6))
                    .overlay {

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    var dateSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Date & Time")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("textPrimary").opacity(0.7))

            HStack(spacing: 10) {

                Image(systemName: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(Color("background"))

                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .font(.caption)
                .foregroundStyle(Color("textPrimary"))

                Divider()
                    .frame(width: 1, height: 25)

                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .font(.caption)
                .foregroundStyle(Color("textPrimary"))
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 46)
            .background(Color(.systemGray6).opacity(0.6))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    var durationSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Duration")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("textPrimary").opacity(0.7))

            Menu {

                ForEach(durations, id: \.self) { duration in

                    Button(duration) {
                        self.duration = duration
                    }
                }

            } label: {

                HStack(spacing: 10) {

                    Image(systemName: "timer")
                        .font(.subheadline)
                        .foregroundStyle(Color("background"))
                        .frame(width: 18)

                    Text(duration)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color("textPrimary"))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 12)
                .frame(minHeight: 46)
                .background(Color(.systemGray6).opacity(0.6))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    var locationSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Location")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("textPrimary").opacity(0.7))

            HStack(alignment: .center, spacing: 8) {

                LocationOption(
                    icon: "video.fill",
                    title: "Google Meet",
                    location: $location
                )

                LocationOption(
                    icon: "figure.walk",
                    title: "In-Office",
                    location: $location
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    var notesSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Notes (Optional)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("textPrimary").opacity(0.7))

            TextField(
                "Add interview notes or instructions...",
                text: $notes,
                axis: .vertical
            )
            .font(.caption)
            .foregroundStyle(Color("textPrimary"))
            .lineLimit(3...10)
            .padding()
            .background(.gray.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}