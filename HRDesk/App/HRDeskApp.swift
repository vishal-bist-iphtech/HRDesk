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

    var body: some Scene {
        WindowGroup {
                
                RootView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(session)
                    .environmentObject(authViewModel)            
        }
        .onChange(of: scenePhase) {

            if scenePhase == .active {

                UIApplication.shared.applicationIconBadgeNumber = 0

                NotificationService.shared.requestPermissionIfNeeded()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationService.shared.syncPendingNotifications()
                }
            }
        }
    }
}
