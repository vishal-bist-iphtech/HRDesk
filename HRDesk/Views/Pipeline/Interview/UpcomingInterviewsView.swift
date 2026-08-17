//
//  UpcomingInterviewsView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI
import CoreData

struct UpcomingInterviewsView: View {

    @EnvironmentObject private var interviewViewModel: InterviewViewModel

    private var upcomingInterviews: [InterviewEntity] {

        let startOfDay = Calendar.current.startOfDay(for: Date())

        return interviewViewModel.interviews
            .filter {

                ($0.status ?? "Scheduled") != "Done"
                && ($0.date ?? .distantPast) >= startOfDay
            }
            .sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }

    var body: some View {

        Group {
            

            if upcomingInterviews.isEmpty {

                ContentUnavailableView(
                    "No Upcoming Interviews",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text(
                        "Scheduled interviews will appear here."
                    )
                )

            } else {

                List(upcomingInterviews, id: \.objectID) { interview in

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
        .navigationTitle("Upcoming Interviews")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    InterviewHistoryView()
                } label: {
                    Text("Show all")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            interviewViewModel.fetchInterviews()
        }
    }
}
