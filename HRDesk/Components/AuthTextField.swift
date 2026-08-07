//
//  AuthTextField.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct AuthTextField: View {
    let icon: String
    let title: String
    @Binding var text: String
    var isSecure = false
    var keyboard: UIKeyboardType = .default

    @State private var showText = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color("textSecondary"))
                .frame(width: 20)

            Group {
                if isSecure && !showText {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .keyboardType(keyboard)
            .textContentType(isSecure ? .password : (keyboard == .emailAddress ? .emailAddress : nil))
            .submitLabel(isSecure ? .go : .next)

            if isSecure {
                Button {
                    showText.toggle()
                } label: {
                    Image(systemName: showText ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    VStack(spacing: 16) {
        AuthTextField(icon: "envelope.fill", title: "Email", text: .constant(""), keyboard: .emailAddress)
        AuthTextField(icon: "lock.fill", title: "Password", text: .constant("secret"), isSecure: true)
    }
    .padding()
}
