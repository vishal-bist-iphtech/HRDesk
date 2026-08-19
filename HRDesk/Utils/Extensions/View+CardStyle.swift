//
//  View+CardStyle.swift
//  HRDesk
//

import SwiftUI

extension View {

    func cardStyle() -> some View {

        self
            .background(
                Color.gray.opacity(0.04)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 16
                )
                .stroke(
                    Color.gray.opacity(0.10),
                    lineWidth: 1
                )
            }
    }
}