//
//  AddInterviewerView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI


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
