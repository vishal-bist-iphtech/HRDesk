//
//  NotificationsListView.swift
//  HRDesk
//
//  Created by HRDesk on 21/08/26.
//

import SwiftUI

struct NotificationsListView: View {

    @EnvironmentObject private var store: AppNotificationStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if store.notifications.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !store.notifications.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            store.markAllAsRead()
                        } label: {
                            Label("Mark all as read", systemImage: "checkmark.circle")
                        }
                        Button(role: .destructive) {
                            store.clearAll()
                        } label: {
                            Label("Clear all", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear {
            // Mark as seen when list is opened - removes red badge
            // Slight delay to allow push animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if store.unreadCount > 0 {
                    store.markAllAsRead()
                }
            }
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            "No Notifications",
            systemImage: "bell.slash",
            description: Text("You're all caught up! Interview and task reminders will appear here.")
        )
    }

    private var listView: some View {
        List {
            ForEach(store.notifications) { item in
                NotificationRow(item: item) {
                    store.markAsRead(id: item.id)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        store.removeNotification(id: item.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
        .scrollContentBackground(.hidden)
        .refreshable {
            // no-op, just for UX
        }
    }
}

private struct NotificationRow: View {

    let item: AppNotification
    var onTap: () -> Void = {}

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 42, height: 42)
                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color("textPrimary"))
                            .lineLimit(1)
                        Spacer()
                        if !item.isRead {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                        }
                    }

                    Text(item.body)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(item.date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                        Text("·")
                            .font(.caption2)
                        Text(item.relativeTime)
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary.opacity(0.9))
                    .padding(.top, 2)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(item.isRead ? Color.gray.opacity(0.12) : Color("background").opacity(0.12), lineWidth: 1)
            }
            .opacity(item.isRead ? 0.92 : 1)
        }
        .buttonStyle(.plain)
    }

    private var iconBackground: Color {
        switch item.type {
        case .interviewScheduled:
            return Color("background")
        case .interviewReminder:
            return Color.orange
        case .todoReminder:
            return Color.red
        case .general:
            return Color.gray
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsListView()
            .environmentObject(AppNotificationStore.shared)
    }
}
