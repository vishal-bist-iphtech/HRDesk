//
//  ChangePasswordView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct ChangePasswordView: View {

    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    let user: UserEntity?

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private var passwordsMatch: Bool {
        newPassword == confirmPassword
    }

    private var isFormValid: Bool {
        !currentPassword.isEmpty
            && newPassword.count >= 6
            && passwordsMatch
    }

    var body: some View {

        Form {

            Section("Current Password") {

                SecureField("Current password", text: $currentPassword)
            }

            Section("New Password") {

                SecureField("New password (min 6 characters)", text: $newPassword)

                SecureField("Confirm new password", text: $confirmPassword)
            }

            Section {

                Button {
                    save()
                } label: {
                    Text("Update Password")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
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

        guard passwordsMatch else {
            showAlert(
                title: "Passwords Don't Match",
                message: "Please make sure your new passwords match."
            )
            return
        }

        guard authViewModel.changePassword(
            user: user,
            currentPassword: currentPassword,
            newPassword: newPassword
        ) else {
            showAlert(
                title: "Incorrect Password",
                message: "Your current password is incorrect."
            )
            return
        }

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
        ChangePasswordView(user: nil)
            .environmentObject(AuthViewModel())
    }
}