//
//  InterviewerRow.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI

struct InterviewerRow: View {
    
    let person: Interviewer

    var onRemove: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 10) {

            Circle()
                .fill(
                    Color("background")
                        .opacity(0.12)
                )
                .frame(
                    width: 34,
                    height: 34
                )
                .overlay {

                    Text(person.initials)
                        .font(
                            .system(
                                size: 11,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            Color("background")
                        )
                }

            VStack(
                alignment: .leading,
                spacing: 1
            ) {

                Text(person.name)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Text(person.role)
                    .font(
                        .system(
                            size: 11
                        )
                    )
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let onRemove {

                Button {
                    onRemove()
                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(
                            Color.gray.opacity(0.4)
                        )
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(minHeight: 46)
        .background(
            Color(.systemGray6).opacity(0.6)
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
            .stroke(
                Color.gray.opacity(0.15),
                lineWidth: 1
            )
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            )
        )
    }
}
