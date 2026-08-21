//
//  ProfileView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject private var session: SessionManager
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var showLogoutConfirm = false

    private var user: UserEntity? {
        session.currentUser
    }

    private var name: String {
        user?.fullName ?? "HR Admin"
    }

    private var email: String {
        user?.email ?? "admin@hrdesk.com"
    }

    private var memberSince: String {
        (user?.createdAt ?? Date()).formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {

        NavigationStack {

            ScrollView(showsIndicators: false) {

                VStack(spacing: 20) {

                    profileHeader

                    accountSection

                    notificationSection

                    supportSection

                    aboutSection

                    logoutButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            session.refreshCurrentUser()
        }
        .confirmationDialog(
            "Logout",
            isPresented: $showLogoutConfirm,
            titleVisibility: .visible
        ) {

            Button("Logout", role: .destructive) {
                session.logout()
            }

            Button("Cancel", role: .cancel) {}

        } message: {

            Text("Are you sure you want to log out of HRDesk?")
        }
    }

    // MARK: - Header

    private var profileHeader: some View {

        CardContainer {

            VStack(spacing: 14) {

                AvatarView(name: name, size: 88)

                VStack(spacing: 4) {

                    Text(name)
                        .font(.title3.bold())
                        .foregroundStyle(Color("textPrimary"))

                    Text(email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Label(memberSince, systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Sections

    private var accountSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Account")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            CardContainer(padding: 4) {

                VStack(spacing: 0) {

                    NavigationLink {
                        EditProfileView(user: user)
                    } label: {
                        SettingsRow(
                            icon: "person.fill",
                            title: "Account Settings",
                            subtitle: "Name & email",
                            tint: Color("background")
                        )
                    }
                    .buttonStyle(.plain)

                    Divider()
                        .padding(.leading, 52)

                    NavigationLink {
                        ChangePasswordView(user: user)
                    } label: {
                        SettingsRow(
                            icon: "key.fill",
                            title: "Change Password",
                            subtitle: "Update your password",
                            tint: .orange
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var notificationSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Preferences")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            CardContainer(padding: 4) {

                NavigationLink {
                    NotificationsSettingsView()
                } label: {
                    SettingsRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Interview & task reminders",
                        tint: .green
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var supportSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Support")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            CardContainer(padding: 4) {

                VStack(spacing: 0) {

                    NavigationLink {
                        HelpSupportView()
                    } label: {
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "FAQs and contact",
                            tint: .purple
                        )
                    }
                    .buttonStyle(.plain)

                    Divider()
                        .padding(.leading, 52)

                    NavigationLink {
                        PrivacyView()
                    } label: {
                        SettingsRow(
                            icon: "shield.fill",
                            title: "Privacy & Security",
                            subtitle: "How your data is used",
                            tint: .blue
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var aboutSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("About")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)

            CardContainer(padding: 4) {

                NavigationLink {
                    AboutView()
                } label: {
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "About HRDesk",
                        subtitle: "Version & legal",
                        tint: .gray
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Logout

    private var logoutButton: some View {

        HRButton(title: "Logout", isSecondary: true) {
            showLogoutConfirm = true
        }
        .padding(.top, 4)
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager())
        .environmentObject(AuthViewModel())
}