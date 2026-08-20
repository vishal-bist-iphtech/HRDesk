//
//  CardContainer.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct CardContainer<Content: View>: View {

    private let content: Content

    private var padding: CGFloat = 16

    private var cornerRadius: CGFloat = 16

    init(
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {

        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.gray.opacity(0.14), lineWidth: 1)
            }
    }
}

#Preview {
    CardContainer {
        Text("Card content")
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}