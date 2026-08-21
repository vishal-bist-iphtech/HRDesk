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
    
    init() {
        checkSession()
    }        
    
    func checkSession() {
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login(with user: UserEntity) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        currentUser = user
        isLoggedIn = true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        currentUser = nil
        isLoggedIn = false
    }

    func refreshCurrentUser() {
        guard let userID = currentUser?.id else {return}

        currentUser = CoreDataService.shared.user(withID: userID)
        objectWillChange.send()
    }
    
}
