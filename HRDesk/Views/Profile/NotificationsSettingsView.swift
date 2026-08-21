//
//  NotificationsSettingsView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI
import UserNotifications

struct NotificationsSettingsView: View {

    @State private var notificationsEnabled = false
    @State private var status: UNAuthorizationStatus = .notDetermined
    @State private var showOpenSettingsAlert = false

    var body: some View {

        Form {

            Section {

                Toggle(
                    isOn: Binding(
                        get: { notificationsEnabled },
                        set: { handleToggle($0) }
                    )
                ) {

                    Label("Reminders", systemImage: "bell.fill")
                }

            } header: {

                Text("Notifications")

            } footer: {

                Text("Receive local notifications for upcoming interviews and task due dates.")
            }

            Section {

                Label(statusLabel, systemImage: systemIcon)

            } header: {

                Text("Status")
            }

            if status == .denied {

                Section {

                    Button("Open Settings") {
                        openSettings()
                    }
                }
            }
        }
        .onAppear(perform: loadStatus)
        .alert(
            "Notifications Disabled",
            isPresented: $showOpenSettingsAlert
        ) {

            Button("Open Settings") {
                openSettings()
            }

            Button("Cancel", role: .cancel) {}

        } message: {

            Text("Enable notifications in Settings to receive interview and task reminders.")
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusLabel: String {

        switch status {

        case .authorized, .provisional:
            return "Enabled"

        case .denied:
            return "Disabled"

        case .notDetermined:
            return "Not requested"

        default:
            return "Unknown"
        }
    }

    private var systemIcon: String {

        switch status {

        case .authorized, .provisional:
            return "checkmark.circle.fill"

        case .denied:
            return "xmark.circle.fill"

        default:
            return "questionmark.circle"
        }
    }

    private func loadStatus() {

        UNUserNotificationCenter.current()
            .getNotificationSettings { settings in

                DispatchQueue.main.async {

                    status = settings.authorizationStatus
                    notificationsEnabled = status == .authorized
                        || status == .provisional
                }
            }
    }

    private func handleToggle(_ on: Bool) {

        if on {

            requestPermission()

        } else {

            notificationsEnabled = false
            UNUserNotificationCenter.current()
                .removeAllPendingNotificationRequests()
        }
    }

    private func requestPermission() {

        NotificationService.shared.requestPermission()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {

            loadStatus()

            if notificationsEnabled {

                NotificationService.shared.syncPendingNotifications()

            } else if status == .denied {

                showOpenSettingsAlert = true
            }
        }
    }

    private func openSettings() {

        if let url = URL(string: UIApplication.openSettingsURLString) {

            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsSettingsView()
    }
}