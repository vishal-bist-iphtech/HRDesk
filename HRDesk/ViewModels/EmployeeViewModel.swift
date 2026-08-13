//
//  EmployeeViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 13/08/26.
//

import Foundation
import Combine
import CoreData

final class EmployeeViewModel: ObservableObject {

    @Published var employees: [EmployeeEntity] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchEmployees()
    }

    func fetchEmployees() {

        employees = coreDataService.fetchEmployees()
    }

    func addEmployee(
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        department: String,
        position: String,
        joiningDate: Date,
        salary: Double
    ) {

        coreDataService.addEmployee(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            department: department,
            position: position,
            joiningDate: joiningDate,
            salary: salary
        )

        fetchEmployees()
    }

    func deleteEmployee(_ employee: EmployeeEntity) {

        coreDataService.deleteEmployee(employee)

        fetchEmployees()
    }
}