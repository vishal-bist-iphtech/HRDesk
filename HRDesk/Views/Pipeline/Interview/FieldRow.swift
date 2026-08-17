//
//  FieldRow.swift
//  HRDesk
//
//  Created by iPHTech 34 on 17/08/26.
//

import SwiftUI

struct FieldRow<Content: View>: View {

    let icon: String

    private let content: Content

    init(
        icon: String,
        @ViewBuilder content: () -> Content
    ) {

        self.icon = icon
        self.content = content()
    }

    var body: some View {

        HStack(spacing: 10) {

            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color("background"))
                .frame(width: 18)

            content
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
