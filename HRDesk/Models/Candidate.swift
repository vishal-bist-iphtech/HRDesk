//
//  Candidate.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import Foundation

struct Candidate: Identifiable {

    let id = UUID()

    let name: String
    let role: String
    let stage: PipelineStage
    let experience: String
    let location: String
    let employmentType: String
    let matchScore: Int
    let appliedDate: String
    let avatarURL: String
    let isFavorite: Bool
    let about: String
    let email: String
    let phone: String
    let website: String

    var initials: String {

        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    static let samples: [Candidate] = [

        Candidate(
            name: "Sophia Carter",
            role: "Product Designer",
            stage: .applied,
            experience: "3 Yrs Exp",
            location: "San Francisco, CA",
            employmentType: "Full-time",
            matchScore: 92,
            appliedDate: "2 days ago",
            avatarURL: "https://randomuser.me/api/portraits/women/44.jpg",
            isFavorite: true,
            about: "Creative Product Designer with 3+ years of experience designing thoughtful digital experiences for web and mobile applications.",
            email: "sophia.carter@gmail.com",
            phone: "(415) 123-4567",
            website: "sofia-carter.com"
        ),

        Candidate(
            name: "Liam Anderson",
            role: "Product Designer",
            stage: .screening,
            experience: "4 Yrs Exp",
            location: "New York, NY",
            employmentType: "Full-time",
            matchScore: 88,
            appliedDate: "1 day ago",
            avatarURL: "https://randomuser.me/api/portraits/men/32.jpg",
            isFavorite: false,
            about: "Product designer focused on user-centered experiences and scalable design systems.",
            email: "liam.anderson@gmail.com",
            phone: "(212) 555-1234",
            website: "liam-anderson.design"
        ),

        Candidate(
            name: "Olivia Bennett",
            role: "Product Designer",
            stage: .interview,
            experience: "5 Yrs Exp",
            location: "Austin, TX",
            employmentType: "Full-time",
            matchScore: 76,
            appliedDate: "5 days ago",
            avatarURL: "https://randomuser.me/api/portraits/women/65.jpg",
            isFavorite: true,
            about: "Experienced designer with a strong background in product strategy and interaction design.",
            email: "olivia.bennett@gmail.com",
            phone: "(512) 555-4567",
            website: "olivia-bennett.io"
        ),

        Candidate(
            name: "Noah Williams",
            role: "Product Designer",
            stage: .offer,
            experience: "6 Yrs Exp",
            location: "Remote",
            employmentType: "Full-time",
            matchScore: 95,
            appliedDate: "2 days ago",
            avatarURL: "https://randomuser.me/api/portraits/men/75.jpg",
            isFavorite: false,
            about: "Senior product designer specializing in digital products and cross-functional collaboration.",
            email: "noah.williams@gmail.com",
            phone: "(555) 555-7890",
            website: "noahwilliams.studio"
        ),

        Candidate(
            name: "Ava Thompson",
            role: "Product Designer",
            stage: .applied,
            experience: "2 Yrs Exp",
            location: "Chicago, IL",
            employmentType: "Full-time",
            matchScore: 68,
            appliedDate: "1 day ago",
            avatarURL: "https://randomuser.me/api/portraits/women/68.jpg",
            isFavorite: false,
            about: "Product designer passionate about creating simple and accessible user experiences.",
            email: "ava.thompson@gmail.com",
            phone: "(312) 555-6789",
            website: "avathompson.art"
        )
    ]
}
