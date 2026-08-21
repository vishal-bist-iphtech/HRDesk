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

    func updateProfile(
        user: UserEntity,
        fullName: String,
        email: String
    ) -> Bool {

        guard let id = user.id else {
            return false
        }

        coreDataService.updateUser(
            id: id,
            fullName: fullName,
            email: email
        )

        user.fullName = fullName
        user.email = email

        return true
    }

    func changePassword(
        user: UserEntity,
        currentPassword: String,
        newPassword: String
    ) -> Bool {

        guard let id = user.id else {
            return false
        }

        guard user.password == currentPassword else {
            return false
        }

        coreDataService.updateUserPassword(
            id: id,
            password: newPassword
        )

        user.password = newPassword

        return true
    }
}
