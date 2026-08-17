//
//  InterviewDetailView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI

struct InterviewDetailView: View {

    @Binding var interviewType: String
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date
    @Binding var duration: String
    @Binding var location: String
    @Binding var notes: String
    @Binding var interviewers: [Interviewer]

    var onAddInterviewer: () -> Void

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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("Interview Details")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color("textPrimary"))
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 12)

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

                    FieldRow(icon: "laptopcomputer") {

                        HStack {

                            Text(interviewType)
                                .font(
                                    .system(
                                        size: 13,
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
                                    size: 10,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

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
                        onAddInterviewer()
                    } label: {

                        FieldRow(icon: "person.badge.plus") {

                            Text("Add Interviewer")
                                .font(
                                    .system(
                                        size: 13,
                                        weight: .medium
                                    )
                                )
                                .foregroundStyle(
                                    Color("textPrimary")
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text("Date")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary").opacity(0.7))

                FieldRow(icon: "calendar") {

                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .font(
                        .system(
                            size: 13,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(Color("textPrimary"))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                Text("Time")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary").opacity(0.7))

                FieldRow(icon: "clock") {

                    DatePicker(
                        "",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .font(
                        .system(
                            size: 13,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(Color("textPrimary"))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

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

                    FieldRow(icon: "timer") {

                        HStack {

                            Text(duration)
                                .font(
                                    .system(
                                        size: 13,
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
                                    size: 10,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

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
                        title: "Walk-in",
                        location: $location
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 6) {

                Text("Notes (Optional)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary").opacity(0.7))

                TextField( "Add interview notes or instructions...",text: $notes,axis: .vertical)
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
}

#Preview {
    InterviewDetailView(
        interviewType: .constant("Design Interview"),
        selectedDate: .constant(Date()),
        selectedTime: .constant(Date()),
        duration: .constant("60 minutes"),
        location: .constant("Google Meet"),
        notes: .constant(""),
        interviewers: .constant([]),
        onAddInterviewer: {}
    )
}
