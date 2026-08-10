//
//  JobDetailView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI
import CoreData

struct JobDetailView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var jobViewModel: JobViewModel

    let job: JobEntity

    @State private var showDeleteConfirmation = false

    var body: some View {

        ScrollView {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text(
                        job.title ?? "Untitled Job"
                    )
                    .font(
                        .title2.weight(.bold)
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                    Text(
                        job.department ?? "No Department"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Text(
                        job.employmentType ?? "Full Time"
                    )
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        Color("textSecondary")
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Color("textSecondary")
                            .opacity(0.12)
                    )
                    .clipShape(Capsule())
                }

                Divider()

                // MARK: - Job Information

                VStack(
                    alignment: .leading,
                    spacing: 14
                ) {

                    Text("Job Information")
                        .font(.headline)
                        .foregroundStyle(
                            Color("textPrimary")
                        )

                    detailRow(
                        icon: "mappin.and.ellipse",
                        title: "Location",
                        value: job.location ?? "Not specified"
                    )

                    detailRow(
                        icon: "briefcase",
                        title: "Experience",
                        value: job.experience ?? "Not specified"
                    )

                    detailRow(
                        icon: "indianrupeesign.circle",
                        title: "Salary",
                        value: job.salaryRange ?? "Not Disclosed"
                    )

                    detailRow(
                        icon: "person.2",
                        title: "Employment Type",
                        value: job.employmentType ?? "Not specified"
                    )
                }

                // MARK: - Job Description

                if let jd = job.jd,
                   !jd.trimmingCharacters(
                       in: .whitespacesAndNewlines
                   ).isEmpty {

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text("Job Description")
                            .font(.headline)
                            .foregroundStyle(
                                Color("textPrimary")
                            )

                        Text(jd)
                            .font(.body)
                            .foregroundStyle(
                                Color("textPrimary")
                            )
                            .lineSpacing(4)
                    }
                }
            }
            .padding()
        }
        .background(
            Color("background")
                .ignoresSafeArea()
        )
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItemGroup(
                placement: .topBarTrailing
            ) {

                NavigationLink {

                    EditJobView(job: job)

                } label: {

                    Image(systemName: "square.and.pencil")
                }

                Button(role: .destructive) {

                    showDeleteConfirmation = true

                } label: {

                    Image(systemName: "trash")
                }
            }
        }
        .confirmationDialog(
            "Delete this job?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {

            Button(
                "Delete",
                role: .destructive
            ) {

                jobViewModel.deleteJob(job)

                dismiss()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {}
        }
    }

    // MARK: - Detail Row

    private func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(
                    Color("textSecondary")
                )
                .frame(
                    width: 34,
                    height: 34
                )
                .background(
                    Color("textSecondary")
                        .opacity(0.10)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 9
                    )
                )

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(
                        .subheadline.weight(.medium)
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )
            }

            Spacer()
        }
    }
}

#Preview {

    NavigationStack {

        JobDetailView(
            job: JobEntity()
        )
        .environmentObject(
            JobViewModel()
        )
    }
}
