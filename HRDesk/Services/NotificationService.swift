//
//  NotificationService.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import Foundation
import UserNotifications
import CoreData

final class NotificationService: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private let options: UNAuthorizationOptions = [.alert, .badge, .sound]

    private override init() {

        super.init()
        center.delegate = self
    }

    func requestPermission() {

        center.requestAuthorization(
            options: options
        ) { granted, error in

            if granted {
                print("Notification permission granted!")
            } else if let error = error {
                print(
                    "Error requesting notification permission\n",
                    error.localizedDescription
                )
            }
        }
    }

    func requestPermissionIfNeeded() {

        center.getNotificationSettings { settings in

            guard settings.authorizationStatus == .notDetermined else {
                return
            }

            self.center.requestAuthorization(
                options: self.options
            ) { _, _ in }
        }
    }

    func authorizationStatus(
        _ completion: @escaping (UNAuthorizationStatus) -> Void
    ) {

        center.getNotificationSettings { settings in

            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    // MARK: - Interviews

    private let interviewReminderOffsets: [Int] = [60, 30, 10]

    private func removePendingInterviewUNNotifications(for id: UUID) {
        var identifiers = interviewReminderOffsets.map {
            interviewNotificationID(for: id, offset: $0)
        }
        identifiers.append(interviewNotificationID(for: id))
        identifiers.append("instant-interview-\(id.uuidString)")
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func scheduleInterviewNotification(for interview: InterviewEntity) {

        guard let id = interview.id,
              let date = interview.date,
              date > Date(),
              (interview.status ?? "Scheduled") != "Done" else {
            return
        }

        // Remove only system notifications, keep in-app store for update handling
        removePendingInterviewUNNotifications(for: id)

        for offset in interviewReminderOffsets {

            let triggerDate = date.addingTimeInterval(TimeInterval(-offset * 60))

            guard triggerDate > Date() else { continue }

            let content = UNMutableNotificationContent()

            content.title = "Upcoming Interview"

            if offset == 60 {
                content.title = "Interview in 1 hour"
            } else {
                content.title = "Interview in \(offset) minutes"
            }

            content.body = interviewNotificationBody(for: interview, minutesBefore: offset)
            content.sound = .default
            content.badge = NSNumber(value: AppNotificationStore.shared.unreadCount + 1)

            addWithAuthorization(
                identifier: interviewNotificationID(for: id, offset: offset),
                content: content,
                trigger: calendarTrigger(at: triggerDate),
                userInfo: ["interviewID": id.uuidString]
            )

            // In-app notification center entry
            AppNotificationStore.shared.addNotification(
                id: interviewNotificationID(for: id, offset: offset),
                title: content.title,
                body: content.body,
                date: triggerDate,
                type: .interviewReminder
            )
        }
    }


    func sendInterviewScheduledNotification(for interview: InterviewEntity) {

        guard let id = interview.id else {return}

        let content = UNMutableNotificationContent()

        content.title = "Interview Scheduled"
        content.body = interviewNotificationBody(for: interview)
        content.sound = .default

        let identifier = "instant-interview-\(id.uuidString)"

        addWithAuthorization(
            identifier: identifier,
            content: content,
            trigger: instantTrigger(),
            userInfo: ["interviewID": id.uuidString]
        )

        AppNotificationStore.shared.addNotification(
            id: identifier,
            title: content.title,
            body: content.body,
            date: Date(),
            type: .interviewScheduled
        )
    }

    func cancelInterviewNotification(for interview: InterviewEntity) {

        guard let id = interview.id else {return}

        removePendingInterviewUNNotifications(for: id)

        // Also remove from in-app center
        var identifiers = interviewReminderOffsets.map {
            interviewNotificationID(for: id, offset: $0)
        }
        identifiers.append(interviewNotificationID(for: id))
        identifiers.append("instant-interview-\(id.uuidString)")
        AppNotificationStore.shared.removeNotifications(ids: identifiers)
    }

    // MARK: - Todos

    private let todoHighPriorityOffsets: [Int] = [30, 5]

    private func removePendingTodoUNNotifications(for id: UUID) {
        var identifiers = todoHighPriorityOffsets.map {
            todoNotificationID(for: id, offset: $0)
        }
        identifiers.append(todoNotificationID(for: id))
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func scheduleTodoNotification(for todo: TodoEntity) {

        guard let id = todo.id,
              let dueDate = todo.dueDate,
              dueDate > Date(),
              !todo.isCompleted else {return}

        removePendingTodoUNNotifications(for: id)

        // Only high priority tasks should trigger notifications
        let priority = todo.priority ?? ""
        guard priority == "High" else {
            // Ensure any previous high-priority reminders are cleared from center
            AppNotificationStore.shared.removeNotifications(ids: todoHighPriorityOffsets.map { todoNotificationID(for: id, offset: $0) } + [todoNotificationID(for: id)])
            return
        }

        for offset in todoHighPriorityOffsets {

            let triggerDate = dueDate.addingTimeInterval(TimeInterval(-offset * 60))

            guard triggerDate > Date() else { continue }

            let content = UNMutableNotificationContent()

            content.title = "High Priority Task"
            content.body = todoNotificationBody(for: todo, minutesBefore: offset)
            content.sound = .default
            content.badge = NSNumber(value: AppNotificationStore.shared.unreadCount + 1)

            addWithAuthorization(
                identifier: todoNotificationID(for: id, offset: offset),
                content: content,
                trigger: calendarTrigger(at: triggerDate),
                userInfo: ["todoID": id.uuidString]
            )

            AppNotificationStore.shared.addNotification(
                id: todoNotificationID(for: id, offset: offset),
                title: content.title,
                body: content.body,
                date: triggerDate,
                type: .todoReminder
            )
        }
    }

    func cancelTodoNotification(for todo: TodoEntity) {

        guard let id = todo.id else {return}

        removePendingTodoUNNotifications(for: id)

        var identifiers = todoHighPriorityOffsets.map {
            todoNotificationID(for: id, offset: $0)
        }
        identifiers.append(todoNotificationID(for: id))
        AppNotificationStore.shared.removeNotifications(ids: identifiers)
    }

    // MARK: - Sync existing data

    func syncPendingNotifications() {

        requestPermissionIfNeeded()

        let coreDataService = CoreDataService.shared

        coreDataService.fetchInterviews()
            .forEach { scheduleInterviewNotification(for: $0) }

        coreDataService.fetchTodos()
            .forEach { scheduleTodoNotification(for: $0) }
    }

    // MARK: - Background logic helpers

    private func calendarTrigger(at date: Date) -> UNCalendarNotificationTrigger {

        UNCalendarNotificationTrigger(
            dateMatching: dateComponents(from: date),
            repeats: false
        )
    }

    private func instantTrigger() -> UNTimeIntervalNotificationTrigger {

        UNTimeIntervalNotificationTrigger(
            timeInterval: 3,
            repeats: false
        )
    }

    private func addWithAuthorization(
        identifier: String,
        content: UNMutableNotificationContent,
        trigger: UNNotificationTrigger,
        userInfo: [String: String]? = nil
    ) {

        guardAuthorization { [weak self] in

            guard let self else {return}

            if let userInfo {
                content.userInfo = userInfo
            }

            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )

            self.center.add(request) { error in

                if let error {
                    print(
                        "Failed to schedule notification (\(identifier)):",
                        error.localizedDescription
                    )
                } else {
                    print("Notification scheduled: \(identifier)")
                }
            }
        }
    }

    private func guardAuthorization(
        then add: @escaping () -> Void
    ) {

        center.getNotificationSettings { settings in

            switch settings.authorizationStatus {

            case .authorized, .provisional, .ephemeral:
                add()

            case .notDetermined:
                self.center.requestAuthorization(
                    options: self.options
                ) { granted, _ in
                    if granted {
                        DispatchQueue.main.async {add()}
                    }
                }

            default:
                print(
                    "Notification not added — permission denied or not available."
                )
            }
        }
    }

    // MARK: - Helpers

    private func interviewNotificationBody(
        for interview: InterviewEntity,
        minutesBefore: Int? = nil
    ) -> String {

        let candidateName = interview.candidate?.fullName ?? "Candidate"
        let interviewType = interview.interviewType ?? "Interview"

        let time = interview.date?
            .formatted(date: .omitted, time: .shortened) ?? ""

        if let minutesBefore {
            if minutesBefore == 60 {
                return "\(interviewType) with \(candidateName) in 1 hour at \(time)"
            }
            return "\(interviewType) with \(candidateName) in \(minutesBefore) minutes at \(time)"
        }

        return "\(interviewType) with \(candidateName) at \(time)"
    }

    private func todoNotificationBody(
        for todo: TodoEntity,
        minutesBefore: Int
    ) -> String {

        let title = todo.title ?? "Your task"
        return "\"\(title)\" is due in \(minutesBefore) minutes"
    }

    private func interviewNotificationID(for id: UUID) -> String {
        "interview-\(id.uuidString)"
    }

    private func interviewNotificationID(for id: UUID, offset: Int) -> String {
        "interview-\(id.uuidString)-\(offset)"
    }

    private func todoNotificationID(for id: UUID) -> String {
        "todo-\(id.uuidString)"
    }

    private func todoNotificationID(for id: UUID, offset: Int) -> String {
        "todo-\(id.uuidString)-\(offset)"
    }

    private func dateComponents(from date: Date) -> DateComponents {

        var components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )

        components.calendar = Calendar.current
        components.timeZone = Calendar.current.timeZone

        return components
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
