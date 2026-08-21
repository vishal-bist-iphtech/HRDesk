//
//  PrivacyView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct PrivacyView: View {

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 20) {

                Text("Your data is stored locally on this device and is never shared with third parties. HRDesk uses it only to power your recruitment workflows.")
                    .font(.subheadline)
                    .foregroundStyle(Color("textPrimary"))

                CardContainer {

                    VStack(alignment: .leading, spacing: 12) {

                        privacyPoint(
                            icon: "lock.fill",
                            tint: .green,
                            title: "Local Storage",
                            detail: "All candidate, job and employee data stays on your device."
                        )

                        privacyPoint(
                            icon: "iphone",
                            tint: .blue,
                            title: "No Tracking",
                            detail: "We do not collect analytics or track your activity."
                        )

                        privacyPoint(
                            icon: "key.fill",
                            tint: .orange,
                            title: "Password Protected",
                            detail: "Your account is protected by the password you set at signup."
                        )
                    }
                }

                Text("If you have any questions about your data, reach out via Help & Support.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func privacyPoint(
        icon: String,
        tint: Color,
        title: String,
        detail: String
    ) -> some View {

        HStack(alignment: .top, spacing: 14) {

            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(tint)
                .clipShape(RoundedRectangle(cornerRadius: 9))

            VStack(alignment: .leading, spacing: 3) {

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("textPrimary"))

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyView()
    }
}