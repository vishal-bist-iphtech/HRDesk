//
//  CandidatesView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct CandidatesView: View {

    private let candidates = [
        ("Emily Watson", "Senior UX Designer", "Applied 2 days ago"),
        ("David Kim", "Android Developer", "Shortlisted"),
        ("Aisha Patel", "HR Specialist", "Interview scheduled")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(candidates, id: \.0) { candidate in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.orange.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(candidate.0.prefix(1))
                                        .font(.headline)
                                        .foregroundStyle(.orange)
                                )

                            VStack(alignment: .leading, spacing: 3) {
                                Text(candidate.0)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Color("textPrimary"))
                                Text(candidate.1)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(candidate.2)
                                .font(.caption2)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color("textSecondary").opacity(0.12))
                                .foregroundStyle(Color("textSecondary"))
                                .clipShape(Capsule())
                        }
                        .padding(12)
                        .background(Color.gray.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .background(Color("background").ignoresSafeArea())
            .navigationTitle("Candidates")
        }
    }
}

#Preview {
    CandidatesView()
}
