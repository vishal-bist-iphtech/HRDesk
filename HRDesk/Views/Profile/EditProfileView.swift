//
//  EditProfileView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct EditProfileView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var session: SessionManager
    @Environment(\.dismiss) private var dismiss

    let user: UserEntity?

    @State private var fullName = ""
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private var trimmedName: String {
        fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isFormValid: Bool {
        !trimmedName.isEmpty
            && trimmedEmail.contains("@")
            && trimmedEmail.contains(".")
    }

    init(user: UserEntity?) {
        self.user = user
        _fullName = State(initialValue: user?.fullName ?? "")
        _email = State(initialValue: user?.email ?? "")
    }

    var body: some View {

        Form {

            Section("Personal Information") {

                TextField("Full Name", text: $fullName)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }

            Section {

                Button {
                    save()
                } label: {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {

                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert(alertTitle, isPresented: $showAlert) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(alertMessage)
        }
    }

    private func save() {

        guard let user else {
            showAlert(
                title: "Session Expired",
                message: "Please log in again."
            )
            return
        }

        guard isFormValid else {
            showAlert(
                title: "Invalid Details",
                message: "Please enter a valid name and email address."
            )
            return
        }

        guard authViewModel.updateProfile(
            user: user,
            fullName: trimmedName,
            email: trimmedEmail
        ) else {
            showAlert(
                title: "Error",
                message: "Something went wrong while saving your profile."
            )
            return
        }

        session.refreshCurrentUser()

        dismiss()
    }

    private func showAlert(title: String, message: String) {

        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: nil)
            .environmentObject(AuthViewModel())
            .environmentObject(SessionManager())
    }
}