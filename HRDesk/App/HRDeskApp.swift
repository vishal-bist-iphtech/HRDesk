//
//  HRDeskApp.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI
import CoreData

@main
struct HRDeskApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var session = SessionManager()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
                
                RootView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(session)
                    .environmentObject(authViewModel)            
        }
    }
}
