//
//  StatCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct StatCard: View {

    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 36, height: 36)
                    .background(tint.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Text(value)
                .font(.title.weight(.semibold))
                .foregroundStyle(Color("textPrimary"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }
}

#Preview {

    StatCard(icon: "person.2.fill", title: "Applied", value: "48", tint: .orange)
}