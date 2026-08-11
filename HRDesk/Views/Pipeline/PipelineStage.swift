//
//  PipelineStage.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

enum PipelineStage: String, CaseIterable {

    case applied
    case screening
    case interview
    case offer
    case hired

    var title: String {

        switch self {

        case .applied:
            return "Applied"

        case .screening:
            return "Screening"

        case .interview:
            return "Interview"

        case .offer:
            return "Offer"

        case .hired:
            return "Hired"
        }
    }

    var icon: String {

        switch self {

        case .applied:
            return "person.badge.plus"

        case .screening:
            return "person.crop.circle.badge.questionmark"

        case .interview:
            return "person.2"

        case .offer:
            return "doc.text"

        case .hired:
            return "checkmark.circle"
        }
    }

    var color: Color {

        switch self {

        case .applied:
            return .purple

        case .screening:
            return .blue

        case .interview:
            return .orange

        case .offer:
            return .teal

        case .hired:
            return .green
        }
    }
}
