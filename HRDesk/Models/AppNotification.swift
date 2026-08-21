//
//  AppNotification.swift
//  HRDesk
//
//  Created by HRDesk on 21/08/26.
//

import Foundation

struct AppNotification: Identifiable, Codable, Equatable, Hashable {
    var id: String
    var title: String
    var body: String
    var date: Date
    var type: NotificationType
    var isRead: Bool

    enum NotificationType: String, Codable {
        case interviewScheduled = "Interview Scheduled"
        case interviewReminder = "Interview Reminder"
        case todoReminder = "Task Reminder"
        case general = "General"
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        date: Date = Date(),
        type: NotificationType = .general,
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.type = type
        self.isRead = isRead
    }

    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    var icon: String {
        switch type {
        case .interviewScheduled, .interviewReminder:
            return "calendar.badge.clock"
        case .todoReminder:
            return "checklist"
        case .general:
            return "bell.fill"
        }
    }

    var tint: String {
        // not used directly, but for future
        switch type {
        case .interviewScheduled: return "background"
        case .interviewReminder: return "background"
        case .todoReminder: return "orange"
        case .general: return "background"
        }
    }
}
