//
//  HRButton.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct HRButton: View {
    let title: String
    var isLoading = false
    var isSecondary = false
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(isSecondary ? Color("textSecondary") : .white)
                }
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSecondary ? Color.clear : Color("textSecondary"))
            .foregroundStyle(isSecondary ? Color("textSecondary") : .white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSecondary ? Color("textSecondary") : .clear, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        HRButton(title: "Sign In") {}
        HRButton(title: "Loading...", isLoading: true) {}
        HRButton(title: "Create Account", isSecondary: true) {}
    }
    .padding()
}
