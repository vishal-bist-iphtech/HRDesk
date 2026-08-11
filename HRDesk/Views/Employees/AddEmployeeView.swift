//
//  AddEmployeeView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct AddEmployeeView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var firstName = ""
    @State private var lastName = ""
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
                    "First Name",
                    text: $firstName
                )

                TextField(
                    "Last Name",
                    text: $lastName
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
                    firstName.isEmpty ||
                    lastName.isEmpty ||
                    email.isEmpty
                )
            }
        }
        .navigationTitle("New Employee")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveEmployee() {

        // Core Data will be connected here later.

        dismiss()
    }
}

#Preview {

    NavigationStack {
        AddEmployeeView()
    }
}
