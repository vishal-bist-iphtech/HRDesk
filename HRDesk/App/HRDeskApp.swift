//
//  HRDeskApp.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI
import CoreData
import UIKit

@main
struct HRDeskApp: App {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var session = SessionManager()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var notificationStore = AppNotificationStore.shared

    var body: some Scene {
        WindowGroup {
                
                RootView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(session)
                    .environmentObject(authViewModel)
                    .environmentObject(notificationStore)
        }
        .onChange(of: scenePhase) {

            if scenePhase == .active {

                // Sync badge with in-app store instead of clearing
                UIApplication.shared.applicationIconBadgeNumber = notificationStore.unreadCount
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(notificationStore.unreadCount) { _ in }
                }

                NotificationService.shared.requestPermissionIfNeeded()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationService.shared.syncPendingNotifications()
                }
            }
        }
    }
}
