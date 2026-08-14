//
//  AddEmployeeView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct AddEmployeeView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var employeeViewModel: EmployeeViewModel

    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var department = ""
    @State private var position = ""
    @State private var joiningDate = Date()
    @State private var salary = ""

    var body: some View {

        Form {

            Section("Personal Information") {

                TextField(
                    "Full Name",
                    text: $name
                )

                TextField(
                    "Email",
                    text: $email
                )
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

                TextField(
                    "Phone Number",
                    text: $phone
                )
                .keyboardType(.phonePad)
            }

            Section("Employment Details") {

                TextField(
                    "Department",
                    text: $department
                )

                TextField(
                    "Position",
                    text: $position
                )

                DatePicker(
                    "Joining Date",
                    selection: $joiningDate,
                    displayedComponents: .date
                )

                TextField(
                    "Salary",
                    text: $salary
                )
                .keyboardType(.numberPad)
            }

            Section {

                Button {
                    saveEmployee()
                } label: {

                    Text("Add Employee")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(
                    name.isEmpty ||
                    email.isEmpty
                )
            }
        }
        .navigationTitle("New Employee")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveEmployee() {

        employeeViewModel.addEmployee(
            name: name,
            email: email,
            phone: phone,
            department: department,
            position: position,
            joiningDate: joiningDate,
            salary: Double(salary) ?? 0
        )

        dismiss()
    }
}

#Preview {

    NavigationStack {
        AddEmployeeView()
    }
    .environmentObject(EmployeeViewModel())
}
