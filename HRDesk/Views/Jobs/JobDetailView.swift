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

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 8) {

                    Text(job.title ?? "Untitled Job")
                    .font(.title2.weight(.bold) )
                    .foregroundStyle(Color("textPrimary"))

                    Text(job.department ?? "No Department")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Text(job.employmentType ?? "Full Time")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("background"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color("background").opacity(0.12))
                    .clipShape(Capsule())

                    Text(job.statusTitle)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(job.statusColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background( job.statusColor.opacity(0.12))
                        .clipShape(Capsule())
                }

                Divider()

                VStack(alignment: .leading, spacing: 14) {

                    Text("Job Information")
                        .font(.headline)
                        .foregroundStyle(Color("textPrimary"))

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

                    detailRow(
                        icon: "circle.circle.fill",
                        title: "Status",
                        value: job.statusTitle,
                        valueColor: job.statusColor
                    )
                }

                if let jd = job.jd,
                   !jd.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Job Description")
                            .font(.headline)
                            .foregroundStyle( Color("textPrimary"))

                        Text(jd)
                            .font(.body)
                            .foregroundStyle(Color("textPrimary"))
                            .lineSpacing(4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItemGroup(placement: .topBarTrailing) {

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
        .confirmationDialog("Delete this job?", isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {

            Button( "Delete", role: .destructive) {

                jobViewModel.deleteJob(job)

                dismiss()
            }

            Button("Cancel", role: .cancel) {}
        }
    }

    private func detailRow(
        icon: String,
        title: String,
        value: String,
        valueColor: Color = .primary
    ) -> some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color("background"))
                .frame(width: 34, height: 34)
                .background(Color("background").opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 9))

            VStack(alignment: .leading, spacing: 2) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(
                        valueColor == .primary
                        ? Color("textPrimary")
                        : valueColor
                    )
            }

            Spacer()
        }
    }
}

#Preview {

    let context = PersistenceController.preview.container.viewContext
    let job = JobEntity(context: context)
    job.title = "Senior iOS Engineer"
    job.department = "Engineering"
    job.location = "Bengaluru"
    job.employmentType = "Full Time"
    job.experience = "3-5 Years"
    job.salaryRange = "₹18-25 LPA"
    job.jd = "Build and own HRDesk's core features."
    job.status = "Open"
    job.createdAt = Date()
    job.isActive = true

    return NavigationStack {
        JobDetailView(job: job)
            .environmentObject(JobViewModel())
    }
}
