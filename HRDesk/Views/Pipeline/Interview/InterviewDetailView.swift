//
//  InterviewDetailView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI

struct InterviewDetailView: View {

    @EnvironmentObject private var interviewViewModel: InterviewViewModel

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
                            interviewViewModel.interviewType = type
                        }
                    }

                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "laptopcomputer")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color("background"))
                            .frame(width: 18)
                        
                        Text(interviewViewModel.interviewType)
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
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                        .stroke(Color.gray.opacity(0.15),lineWidth: 1)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                        )
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
                            .stroke(Color.gray.opacity(0.15),lineWidth: 1)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10,style: .continuous)
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(alignment: .leading,spacing: 6) {

                Text("Date & Time")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary").opacity(0.7))

                HStack(spacing: 10) {

                    Image(systemName: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(Color("background"))
                    
                    DatePicker("", selection: $interviewViewModel.selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .font(.caption)
                    .foregroundStyle(Color("textPrimary"))
                    
                    Divider()
                        .frame(width: 1,height: 25)
                    
                    DatePicker("", selection: $interviewViewModel.selectedTime, displayedComponents: .hourAndMinute)
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
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                    .stroke(Color.gray.opacity(0.15),lineWidth: 1)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                )
                   
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 6) {

                Text("Duration")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary").opacity(0.7))

                Menu {

                    ForEach(durations, id: \.self) { duration in

                        Button(duration) {interviewViewModel.duration = duration}
                    }

                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "timer")
                            .font(.subheadline)
                            .foregroundStyle(Color("background"))
                            .frame(width: 18)
                        
                        Text(interviewViewModel.duration)
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
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                        .stroke(Color.gray.opacity(0.15),lineWidth: 1)
                        }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                    )
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
                        location: $interviewViewModel.location
                    )

                    LocationOption(
                        icon: "figure.walk",
                        title: "In-Office",
                        location: $interviewViewModel.location
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            VStack(alignment: .leading, spacing: 6) {

                Text("Notes (Optional)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary").opacity(0.7))

                TextField( "Add interview notes or instructions...",text: $interviewViewModel.notes,axis: .vertical)
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
//
//#Preview {
//    InterviewDetailView(
//        interviewType: .constant("Design Interview"),
//        selectedDate: .constant(Date()),
//        selectedTime: .constant(Date()),
//        duration: .constant("60 minutes"),
//        location: .constant("Google Meet"),
//        notes: .constant(""),
//        interviewers: .constant([]),
//        onAddInterviewer: {}
//    )
//}
