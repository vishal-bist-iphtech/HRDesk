//
//  ProfileView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject private var session: SessionManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    avatarSection

                    VStack(spacing: 0) {
                        settingsRow(icon: "person.fill", title: "Account Settings", tint: Color("textSecondary"))
                        Divider().padding(.leading, 48)
                        settingsRow(icon: "bell.fill", title: "Notifications", tint: .orange)
                        Divider().padding(.leading, 48)
                        settingsRow(icon: "shield.fill", title: "Privacy & Security", tint: .green)
                        Divider().padding(.leading, 48)
                        settingsRow(icon: "questionmark.circle.fill", title: "Help & Support", tint: .purple)
                    }
                    .background(Color.gray.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    HRButton(title: "Logout", isSecondary: true) {
                        session.logout()
                    }
                }
                .padding()
            }
            .background(Color("background").ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color("textSecondary"))
                .frame(width: 88, height: 88)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                )

            Text("HR Admin")
                .font(.title3.bold())
                .foregroundStyle(Color("textPrimary"))

            Text("admin@hrdesk.com")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 16)
    }

    private func settingsRow(icon: String, title: String, tint: Color) -> some View {
        Button {
            // Placeholder
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                    .frame(width: 24)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(Color("textPrimary"))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionManager())
}
