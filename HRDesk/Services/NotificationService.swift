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

    // MARK: - Authorization

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

    func scheduleInterviewNotification(for interview: InterviewEntity) {

        guard let id = interview.id,
              let date = interview.date,
              date > Date(),
              (interview.status ?? "Scheduled") != "Done" else {
            return
        }

        cancelInterviewNotification(for: interview)

        let content = UNMutableNotificationContent()

        content.title = "Upcoming Interview"
        content.body = interviewNotificationBody(for: interview)
        content.sound = .default

        addWithAuthorization(
            identifier: interviewNotificationID(for: id),
            content: content,
            trigger: calendarTrigger(at: date),
            userInfo: ["interviewID": id.uuidString]
        )
    }


    func sendInterviewScheduledNotification(for interview: InterviewEntity) {

        guard let id = interview.id else {return}

        let content = UNMutableNotificationContent()

        content.title = "Interview Scheduled"
        content.body = interviewNotificationBody(for: interview)
        content.sound = .default

        addWithAuthorization(
            identifier: "instant-interview-\(id.uuidString)",
            content: content,
            trigger: instantTrigger(),
            userInfo: ["interviewID": id.uuidString]
        )
    }

    func cancelInterviewNotification(for interview: InterviewEntity) {

        guard let id = interview.id else {return}

        center.removePendingNotificationRequests(
            withIdentifiers: [
                interviewNotificationID(for: id),
                "instant-interview-\(id.uuidString)"
            ]
        )
    }

    // MARK: - Todos

    func scheduleTodoNotification(for todo: TodoEntity) {

        guard let id = todo.id,
              let dueDate = todo.dueDate,
              dueDate > Date(),
              !todo.isCompleted else {return}

        cancelTodoNotification(for: todo)

        let content = UNMutableNotificationContent()

        content.title = "Task Due"
        content.body = todo.title ?? "Your task is due"
        content.sound = .default

        addWithAuthorization(
            identifier: todoNotificationID(for: id),
            content: content,
            trigger: calendarTrigger(at: dueDate),
            userInfo: ["todoID": id.uuidString]
        )
    }

    func cancelTodoNotification(for todo: TodoEntity) {

        guard let id = todo.id else {return}

        center.removePendingNotificationRequests(
            withIdentifiers: [
                todoNotificationID(for: id)
            ]
        )
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
        for interview: InterviewEntity
    ) -> String {

        let candidateName = interview.candidate?.fullName ?? "Candidate"
        let interviewType = interview.interviewType ?? "Interview"

        let time = interview.date?
            .formatted(date: .omitted, time: .shortened) ?? ""

        return "\(interviewType) with \(candidateName) at \(time)"
    }

    private func interviewNotificationID(for id: UUID) -> String {
        "interview-\(id.uuidString)"
    }

    private func todoNotificationID(for id: UUID) -> String {
        "todo-\(id.uuidString)"
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
