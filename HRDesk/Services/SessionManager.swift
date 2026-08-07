//
//  SessionManager.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI
import Combine

final class SessionManager: ObservableObject {
    
    @Published var isLoggedIn = false
    
    init() {
        checkSession()
    }
    
    func checkSession() {
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        isLoggedIn = true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        isLoggedIn = false
    }
    
}
