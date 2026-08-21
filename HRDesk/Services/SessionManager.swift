//
//  SessionManager.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI
import Combine
import CoreData

final class SessionManager: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var currentUser: UserEntity?
    
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let loggedInUserID = "loggedInUserID"
    }
    
    init() {
        checkSession()
    }        
    
    func checkSession() {
        isLoggedIn = UserDefaults.standard.bool(forKey: Keys.isLoggedIn)

        // Restore currentUser from persisted ID if needed
        if isLoggedIn, currentUser == nil,
           let idString = UserDefaults.standard.string(forKey: Keys.loggedInUserID),
           let id = UUID(uuidString: idString) {
            currentUser = CoreDataService.shared.user(withID: id)
            // If user no longer exists, clear session
            if currentUser == nil {
                logout()
            }
        }
    }
    
    func login(with user: UserEntity) {
        UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
        if let id = user.id?.uuidString {
            UserDefaults.standard.set(id, forKey: Keys.loggedInUserID)
        }
        currentUser = user
        isLoggedIn = true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: Keys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: Keys.loggedInUserID)
        currentUser = nil
        isLoggedIn = false
    }

    func refreshCurrentUser() {
        // Prefer persisted ID if currentUser is nil (e.g. after relaunch)
        let userID: UUID? = currentUser?.id ?? {
            guard let idString = UserDefaults.standard.string(forKey: Keys.loggedInUserID),
                  let id = UUID(uuidString: idString) else { return nil }
            return id
        }()

        guard let userID else { return }

        currentUser = CoreDataService.shared.user(withID: userID)
        objectWillChange.send()
    }
    
}
