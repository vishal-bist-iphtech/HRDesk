//
//  SignupView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct SignupView: View {

    @EnvironmentObject private var session: SessionManager
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var isLoading = false
    @State private var showAlert = false

    private var passwordsMatch: Bool {
        password == confirmPassword
    }

    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        password.count >= 8 &&
        passwordsMatch
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                header
                formFields
                signupButton
                footer
            }
            .padding(.horizontal, 24)
            .padding(.top, 36)
            .padding(.bottom, 32)
        }
        .background(Color("background").ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .alert("Passwords Don't Match", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please make sure your passwords match before continuing.")
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 36))
                .foregroundStyle(Color("textSecondary"))
                .frame(width: 80, height: 80)
                .background(Color("textSecondary").opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text("Create Account")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(Color("textPrimary"))

            Text("Join HRDesk and start building your team")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var formFields: some View {
        VStack(spacing: 14) {
            AuthTextField(icon: "person.fill", title: "Full Name", text: $fullName, keyboard: .default)
            AuthTextField(icon: "envelope.fill", title: "Email", text: $email, keyboard: .emailAddress)
            AuthTextField(icon: "lock.fill", title: "Password (min 6 characters)", text: $password, isSecure: true)
            AuthTextField(icon: "lock.rotation", title: "Confirm Password", text: $confirmPassword, isSecure: true)
        }
        .padding(.top, 8)
    }

    private var signupButton: some View {
        HRButton(title: "Create Account", isLoading: isLoading) {
            signup()
        }
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundStyle(.secondary)
            NavigationLink("Login") {
                LoginView()
            }
            .foregroundStyle(Color("textSecondary"))
            .fontWeight(.semibold)
        }
        .font(.subheadline)
    }

    private func signup() {
        guard passwordsMatch else {
            showAlert = true
            return
        }
        guard isFormValid else { return }

        let fullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if let user = authViewModel.signUp(fullName: fullName, email: email, password: password) {
                isLoading = false
                session.login(with: user)
            } else {
                isLoading = false
                showAlert = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignupView()
            .environmentObject(SessionManager())
            .environmentObject(AuthViewModel())
    }
}
