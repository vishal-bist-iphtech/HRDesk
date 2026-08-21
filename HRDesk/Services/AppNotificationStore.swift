//
//  AppNotificationStore.swift
//  HRDesk
//
//  Created by HRDesk on 21/08/26.
//

import Foundation
import Combine
import UIKit
import UserNotifications

final class AppNotificationStore: ObservableObject {

    static let shared = AppNotificationStore()

    @Published var notifications: [AppNotification] = [] {
        didSet {
            save()
            updateBadge()
            objectWillChange.send()
        }
    }

    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    private let storageKey = "hrdesk_app_notifications_v1"
    private let queue = DispatchQueue(label: "AppNotificationStore.queue")

    init() {
        load()
        updateBadge()
    }

    // MARK: - Persistence

    private func save() {
        queue.async { [weak self] in
            guard let self else { return }
            if let data = try? JSONEncoder().encode(self.notifications) {
                UserDefaults.standard.set(data, forKey: self.storageKey)
            }
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([AppNotification].self, from: data) else {
            notifications = []
            return
        }
        notifications = decoded.sorted { $0.date > $1.date }
    }

    private func updateBadge() {
        let count = unreadCount
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
            if #available(iOS 16.0, *) {
                UNUserNotificationCenter.current().setBadgeCount(count) { _ in }
            }
        }
    }

    // MARK: - Public API

    func addNotification(
        id: String,
        title: String,
        body: String,
        date: Date = Date(),
        type: AppNotification.NotificationType = .general
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            // Deduplicate by id - preserve read state if date unchanged
            if let idx = self.notifications.firstIndex(where: { $0.id == id }) {
                var existing = self.notifications[idx]
                let dateChanged = abs(existing.date.timeIntervalSince(date)) > 60
                let contentChanged = existing.title != title || existing.body != body
                existing.title = title
                existing.body = body
                existing.date = date
                existing.type = type
                // Only mark unread again if date/content meaningfully changed
                if dateChanged || contentChanged {
                    existing.isRead = false
                }
                self.notifications[idx] = existing
                self.notifications.sort { $0.date > $1.date }
            } else {
                let item = AppNotification(
                    id: id,
                    title: title,
                    body: body,
                    date: date,
                    type: type,
                    isRead: false
                )
                self.notifications.insert(item, at: 0)
                self.notifications.sort { $0.date > $1.date }
            }
        }
    }

    func removeNotifications(ids: [String]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.notifications.removeAll { ids.contains($0.id) }
        }
    }

    func removeNotification(id: String) {
        removeNotifications(ids: [id])
    }

    func markAllAsRead() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            var updated = self.notifications
            for i in updated.indices {
                updated[i].isRead = true
            }
            self.notifications = updated
            self.clearSystemBadge()
        }
    }

    func markAsRead(id: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let idx = self.notifications.firstIndex(where: { $0.id == id }) {
                self.notifications[idx].isRead = true
            }
        }
    }

    func clearAll() {
        DispatchQueue.main.async { [weak self] in
            self?.notifications.removeAll()
            self?.clearSystemBadge()
        }
    }

    private func clearSystemBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
            if #available(iOS 16.0, *) {
                UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
            }
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }

    // MARK: - Helpers for legacy data

    func hasUnseen() -> Bool {
        unreadCount > 0
    }
}
