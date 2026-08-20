//
//  SettingsRow.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct SettingsRow: View {

    let icon: String
    let title: String
    var subtitle: String? = nil
    let tint: Color

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(tint)
                .clipShape(RoundedRectangle(cornerRadius: 9))

            VStack(alignment: .leading, spacing: 2) {

                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color("textPrimary"))

                if let subtitle {

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .contentShape(Rectangle())
    }
}

#Preview {
    SettingsRow(
        icon: "person.fill",
        title: "Account Settings",
        subtitle: "Name, email",
        tint: Color("background")
    )
    .padding()
}