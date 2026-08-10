//
//  LoginView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var session: SessionManager
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var showForgotAlert = false

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                header
                formFields
                loginButton
                footer
                forgotPassword
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .padding(.bottom, 32)
        }
        .background(Color("background").ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .alert("Reset Password", isPresented: $showForgotAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Koi nhi hota hai, ye try krke dekho - 'qwer1234'.")
                .fontWeight(.bold)
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.3.sequence.fill")
                .font(.system(size: 36))
                .foregroundStyle(Color("textSecondary"))
                .frame(width: 80, height: 80)
                .background(Color("textSecondary").opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text("Welcome Back")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(Color("textPrimary"))

            Text("Sign in to continue to HRDesk")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var formFields: some View {
        VStack(spacing: 14) {
            AuthTextField(icon: "envelope.fill", title: "Email", text: $email, keyboard: .emailAddress)
            AuthTextField(icon: "lock.fill", title: "Password", text: $password, isSecure: true)
        }
        .padding(.top, 8)
    }

    private var forgotPassword: some View {
        HStack {
          
            Button {
                showForgotAlert = true
            } label: {
                Text("Forgot Password?")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textSecondary"))
            }
        }
    }

    private var loginButton: some View {
        HRButton(title: "Sign In", isLoading: isLoading) {
            login()
        }
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundStyle(.secondary)
            NavigationLink("Sign Up") {
                SignupView()
            }
            .foregroundStyle(Color("textSecondary"))
            .fontWeight(.semibold)
        }
        .font(.subheadline)
    }

    private func login() {
        guard isFormValid else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            session.login()
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(SessionManager())
    }
}
