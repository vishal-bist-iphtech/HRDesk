//
//  JobStatus.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI
import CoreData

extension JobEntity {

    var statusTitle: String {
        status ?? "Open"
    }

    var statusColor: Color {

        switch statusTitle.lowercased() {

        case "open":
            return .green

        case "on hold":
            return .orange

        case "closed":
            return .red

        default:
            return .gray
        }
    }
}
