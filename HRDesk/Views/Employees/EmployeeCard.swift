//
//  EmployeeCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 13/08/26.
//

import SwiftUI
import CoreData

struct EmployeeCard: View {

    let employee: EmployeeEntity

    var onEdit: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 12) {

                AvatarView(
                    name: "\(employee.firstName ?? "") \(employee.lastName ?? "")",
                    size: 44
                )

                VStack(alignment: .leading, spacing: 3) {

                    Text("\(employee.firstName ?? "") \(employee.lastName ?? "")")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("textPrimary"))
                        .lineLimit(1)

                    Text(employee.position ?? "—")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                Menu {

                    if let onEdit {
                        Button(
                            "Edit Employee",
                            systemImage: "pencil"
                        ) {
                            onEdit()
                        }
                    }

                    if let onDelete {
                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive
                        ) {
                            onDelete()
                        }
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

            HStack(spacing: 8) {

                Text(employee.department ?? "General")
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Color("background")
                            .opacity(0.12)
                    )
                    .foregroundStyle(Color("background"))
                    .clipShape(Capsule())

                Text("Joined \(formattedDate(employee.joiningDate))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }

            Divider()

            HStack(spacing: 12) {

                Label(
                    formattedSalary(employee.salary),
                    systemImage: "indianrupeesign.circle"
                )
                .lineLimit(1)

                Label(
                    employee.email ?? "—",
                    systemImage: "envelope"
                )
                .lineLimit(1)

                Spacer(minLength: 0)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .overlay {

            RoundedRectangle(cornerRadius: 12)
            .stroke(
                Color.gray.opacity(0.15)
            )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }

    private func formattedSalary(_ salary: Double) -> String {

        let lakhs = salary / 100_000

        if lakhs >= 1 {
            return String(format: "₹%.1f LPA", lakhs)
        }

        return String(format: "₹%.0f", salary)
    }

    private func formattedDate(_ date: Date?) -> String {

        guard let date else {
            return "—"
        }

        return date.formatted(
            .dateTime.month(.abbreviated).year()
        )
    }
}

#Preview {

    let context = PersistenceController.preview.container.viewContext
    let employee = EmployeeEntity(context: context)
    employee.firstName = "James"
    employee.lastName = "Wilson"
    employee.position = "Engineering Manager"
    employee.department = "Engineering"
    employee.email = "james.wilson@hrdesk.com"
    employee.salary = 3200000
    employee.joiningDate = Date()

    return ScrollView {
        VStack(spacing: 12) {
            EmployeeCard(employee: employee)
        }
        .padding(.horizontal)
    }
    .background(Color("background"))
}