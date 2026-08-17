//
//  Interview.swift
//  HRDesk
//
//  Created by iPHTech 34 on 14/08/26.
//

import Foundation

struct Interviewer: Identifiable {

    let id = UUID()
    let name: String
    let role: String
    let employeeID: UUID?

    var initials: String {

        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    init(
        name: String,
        role: String,
        employeeID: UUID? = nil
    ) {

        self.name = name
        self.role = role
        self.employeeID = employeeID
    }
}
