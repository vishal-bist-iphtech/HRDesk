//
//  AuthViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {

    private let coreDataService = CoreDataService.shared

    func signUp(
        fullName: String,
        email: String,
        password: String
    ) -> UserEntity? {

        coreDataService.addUser(
            fullName: fullName,
            email: email,
            password: password
        )
    }

    func login(
        email: String,
        password: String
    ) -> UserEntity? {

        coreDataService.authenticateUser(
            email: email,
            password: password
        )
    }
}
