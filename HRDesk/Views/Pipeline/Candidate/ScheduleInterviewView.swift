//
//  ScheduleInterviewView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 14/08/26.
//

import SwiftUI

struct ScheduleInterviewView: View {

    let candidate: Candidate

    @Environment(\.dismiss) private var dismiss

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

                candidateHeader

                Divider()
                    .padding(.horizontal, 16)

                interviewDetails
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
                "\(interviewType) for \(candidate.name) has been scheduled on \(formattedScheduledDate)."
            )
        }
    }
}

// MARK: - Candidate Header

private extension ScheduleInterviewView {

    var candidateHeader: some View {

        HStack(
            spacing: 12
        ) {

            candidateImage

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(candidate.name)
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Text(candidate.role)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 7) {

                    Text(
                        candidate.stage.rawValue
                    )
                    .font(
                        .system(
                            size: 9,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color("background")
                    )
                    .padding(
                        .horizontal,
                        7
                    )
                    .padding(
                        .vertical,
                        3
                    )
                    .background(
                        Color("background")
                            .opacity(0.08)
                    )
                    .clipShape(
                        Capsule()
                    )

                    Text(candidate.appliedDate)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(
                alignment: .trailing,
                spacing: 2
            ) {

                Text("\(candidate.matchScore)%")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.green)

                Text("Match Score")
                    .font(
                        .system(
                            size: 7,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    var candidateImage: some View {

        Circle()
            .fill(
                Color("background")
                    .opacity(0.10)
            )
            .frame(
                width: 48,
                height: 48
            )
            .overlay {

                Text(candidate.initials)
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color("background")
                    )
            }
            .overlay(alignment: .bottomTrailing) {

                Image(systemName: "star.fill")
                    .font(.system(size: 7))
                    .foregroundStyle(.yellow)
                    .frame(
                        width: 15,
                        height: 15
                    )
                    .background(.white)
                    .clipShape(Circle())
            }
    }
}

// MARK: - Interview Details

private extension ScheduleInterviewView {

    var interviewDetails: some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            Text("Interview Details")
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    Color("textPrimary")
                )
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 12)

            interviewTypeRow

            interviewersSection

            dateRow

            timeRow

            durationRow

            locationRow

            notesRow
        }
    }

    // MARK: Interview Type

    var interviewTypeRow: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            fieldLabel("Interview Type")

            Menu {

                ForEach(
                    interviewTypes,
                    id: \.self
                ) { type in

                    Button(type) {
                        interviewType = type
                    }
                }

            } label: {

                HStack {

                    Text(interviewType)
                        .font(
                            .system(
                                size: 11,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color("textPrimary")
                        )

                    Spacer()

                    Image(
                        systemName: "chevron.down"
                    )
                    .font(
                        .system(
                            size: 8,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .frame(height: 34)
                .background(
                    Color.gray.opacity(0.025)
                )
                .overlay {

                    RoundedRectangle(
                        cornerRadius: 7
                    )
                    .stroke(
                        Color.gray.opacity(0.12),
                        lineWidth: 1
                    )
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 7
                    )
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: Interviewers

    var interviewersSection: some View {

        VStack(
            alignment: .leading,
            spacing: 9
        ) {

            fieldLabel("Interviewers")

            VStack(
                spacing: 8
            ) {

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

                    HStack(spacing: 6) {

                        Image(systemName: "plus")
                            .font(
                                .system(
                                    size: 11,
                                    weight: .semibold
                                )
                            )

                        Text("Add Interviewer")
                            .font(
                                .system(
                                    size: 11,
                                    weight: .medium
                                )
                            )
                    }
                    .foregroundStyle(
                        Color("background")
                    )
                }
                .padding(.top, 2)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 13)
    }

    // MARK: Date

    var dateRow: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            fieldLabel("Date")

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .font(.caption)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 8)
            .frame(height: 34)
            .background(
                Color.gray.opacity(0.025)
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 7
                )
                .stroke(
                    Color.gray.opacity(0.10),
                    lineWidth: 1
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: Time

    var timeRow: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            fieldLabel("Time")

            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .font(.caption)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 8)
            .frame(height: 34)
            .background(
                Color.gray.opacity(0.025)
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 7
                )
                .stroke(
                    Color.gray.opacity(0.10),
                    lineWidth: 1
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: Duration

    var durationRow: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            fieldLabel("Duration")

            Menu {

                ForEach(
                    durations,
                    id: \.self
                ) { duration in

                    Button(duration) {
                        self.duration = duration
                    }
                }

            } label: {

                HStack {

                    Text(duration)
                        .font(
                            .system(
                                size: 11,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color("textPrimary")
                        )

                    Spacer()

                    Image(
                        systemName: "chevron.down"
                    )
                    .font(
                        .system(
                            size: 8,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .frame(height: 34)
                .background(
                    Color.gray.opacity(0.025)
                )
                .overlay {

                    RoundedRectangle(
                        cornerRadius: 7
                    )
                    .stroke(
                        Color.gray.opacity(0.10),
                        lineWidth: 1
                    )
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 7
                    )
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: Location

    var locationRow: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            fieldLabel("Location")

            HStack {

                Text(location)
                    .font(
                        .system(
                            size: 11,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Spacer()

                Image(
                    systemName: "video.fill"
                )
                .font(.system(size: 12))
                .foregroundStyle(
                    Color("background")
                )
            }
            .padding(.horizontal, 10)
            .frame(height: 34)
            .background(
                Color.gray.opacity(0.025)
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 7
                )
                .stroke(
                    Color.gray.opacity(0.10),
                    lineWidth: 1
                )
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 7
                )
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    // MARK: Notes

    var notesRow: some View {

        VStack(
            alignment: .leading,
            spacing: 5
        ) {

            fieldLabel("Notes (Optional)")

            TextField(
                "Add interview notes or instructions...",
                text: $notes,
                axis: .vertical
            )
            .font(
                .system(
                    size: 11,
                    weight: .regular
                )
            )
            .foregroundStyle(
                Color("textPrimary")
            )
            .lineLimit(3...5)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(
                minHeight: 48,
                alignment: .topLeading
            )
            .background(
                Color.gray.opacity(0.025)
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 7
                )
                .stroke(
                    Color.gray.opacity(0.10),
                    lineWidth: 1
                )
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 7
                )
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    // MARK: Label

    func fieldLabel(
        _ title: String
    ) -> some View {

        Text(title)
            .font(
                .system(
                    size: 9,
                    weight: .medium
                )
            )
            .foregroundStyle(.secondary)
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

            interviewViewModel.scheduleInterview(
                candidateID: candidate.id,
                candidateName: candidate.name,
                candidateRole: candidate.role,
                interviewType: interviewType,
                date: scheduledDate,
                duration: duration,
                location: location,
                notes: notes,
                interviewers: interviewers
            )

            showScheduledConfirmation = true

        } label: {

            Text("Schedule Interview")
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    maxWidth: .infinity
                )
                .frame(height: 40)
                .background(
                    Color("background")
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 7
                    )
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Color("background")
        )
    }

    func formattedScheduledDate() -> String {

        scheduledDate.formatted(
            date: .abbreviated,
            time: .shortened
        )
    }
}

// MARK: - Interviewer

struct InterviewerRow: View {

    let person: Interviewer

    var onRemove: (() -> Void)?

    var body: some View {

        HStack(spacing: 10) {

            Circle()
                .fill(
                    Color("background")
                        .opacity(0.10)
                )
                .frame(
                    width: 30,
                    height: 30
                )
                .overlay {

                    Text(person.initials)
                        .font(
                            .system(
                                size: 9,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            Color("background")
                        )
                }

            VStack(
                alignment: .leading,
                spacing: 1
            ) {

                Text(person.name)
                    .font(
                        .system(
                            size: 10,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Text(person.role)
                    .font(
                        .system(
                            size: 8
                        )
                    )
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let onRemove {

                Button {
                    onRemove()
                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(
                            Color.gray.opacity(0.4)
                        )
                }
            }
        }
    }
}

// MARK: - Add Interviewer

struct AddInterviewerView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var employeeViewModel: EmployeeViewModel

    var onSelect: (Interviewer) -> Void

    @State private var searchText = ""

    private var filteredEmployees: [EmployeeEntity] {

        guard !searchText.isEmpty else {
            return employeeViewModel.employees
        }

        let query = searchText.lowercased()

        return employeeViewModel.employees.filter { employee in

            let fullName = (employee.name ?? "").lowercased()

            return fullName.contains(query)
                || employee.position?.lowercased().contains(query) == true
                || employee.department?.lowercased().contains(query) == true
        }
    }

    var body: some View {

        NavigationStack {

            Group {

                if employeeViewModel.employees.isEmpty {

                    ContentUnavailableView(
                        "No Employees Found",
                        systemImage: "person.3",
                        description: Text("Add employees to the team before assigning interviewers.")
                    )

                } else if filteredEmployees.isEmpty {

                    ContentUnavailableView(
                        "No Results",
                        systemImage: "magnifyingglass",
                        description: Text("No employees match \"\(searchText)\".")
                    )

                } else {

                    List(filteredEmployees, id: \.objectID) { employee in

                        Button {

                            onSelect(
                                Interviewer(
                                    name:
                                        (employee.name ?? "")
                                        .trimmingCharacters(in: .whitespacesAndNewlines),
                                    role: employee.position ?? "",
                                    employeeID: employee.id
                                )
                            )

                            dismiss()

                        } label: {

                            HStack(spacing: 12) {

                                AvatarView(
                                    name: employee.name ?? "—",
                                    size: 38
                                )

                                VStack(
                                    alignment: .leading,
                                    spacing: 2
                                ) {

                                    Text(employee.name ?? "—")
                                    .font(
                                        .subheadline.weight(.semibold)
                                    )
                                    .foregroundStyle(Color("textPrimary"))

                                    Text(employee.position ?? "—")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color("background"))
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Interviewers")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "Search employees"
            )
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                employeeViewModel.fetchEmployees()
            }
        }
    }
}
