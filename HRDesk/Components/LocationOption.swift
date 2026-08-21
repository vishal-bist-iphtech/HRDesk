//
//  LocationOption.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI

struct LocationOption: View {

    let icon: String
    let title: String

    @Binding var location: String

    var body: some View {

        let isSelected = location == title

        Button {
            location = title
        } label: {

            HStack(spacing: 10) {

                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(
                        isSelected ? .white : Color("background")
                    )
                    .frame(width: 14)

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(
                        isSelected ? .white : Color("textPrimary")
                    )

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 46)
            .background(
                isSelected ? Color("background") : Color(.systemGray6).opacity(0.6)
            )
            .overlay {

                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(
                    isSelected ? Color("background") : Color.gray.opacity(0.15),
                    lineWidth: 1
                )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
        }
        .buttonStyle(.plain)
    }
}
