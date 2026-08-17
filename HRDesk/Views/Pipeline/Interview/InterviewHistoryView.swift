//
//  InterviewHistoryView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI
import CoreData

struct InterviewHistoryView: View {

    @EnvironmentObject private var interviewViewModel: InterviewViewModel

    private var historyInterviews: [InterviewEntity] {

        let startOfDay = Calendar.current.startOfDay(for: Date())

        return interviewViewModel.interviews
            .filter {

                ($0.status ?? "Scheduled") == "Done"
                || ($0.date ?? Date()) < startOfDay
            }
            .sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
    }

    var body: some View {

        Group {

            if historyInterviews.isEmpty {

                ContentUnavailableView(
                    "No Interview History",
                    systemImage: "clock.arrow.circlepath",
                    description: Text(
                        "Interviews marked as done or already past will appear here."
                    )
                )

            } else {

                List(historyInterviews, id: \.objectID) { interview in

                    InterviewCard(interview: interview)
                        .listRowSeparator(.hidden)
                        .listRowInsets(
                            EdgeInsets(
                                top: 6,
                                leading: 16,
                                bottom: 6,
                                trailing: 16
                            )
                        )
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Interview History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            interviewViewModel.fetchInterviews()
        }
    }
}
