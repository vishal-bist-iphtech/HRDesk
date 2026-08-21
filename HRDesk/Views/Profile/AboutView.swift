//
//  AboutView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI

struct AboutView: View {

    private var appVersion: String {

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"

        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"

        return "\(version) (\(build))"
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 20) {

                CardContainer {

                    VStack(spacing: 14) {

                        Image(systemName: "person.3.sequence.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                            .frame(width: 88, height: 88)
                            .background(Color("background"))
                            .clipShape(RoundedRectangle(cornerRadius: 22))

                        Text("HRDesk")
                            .font(.title2.bold())
                            .foregroundStyle(Color("textPrimary"))

                        Text(appVersion)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                CardContainer(padding: 4) {

                    VStack(spacing: 0) {

                        aboutRow(title: "Software", value: "HRDesk")

                        Divider()
                            .padding(.leading, 16)

                        aboutRow(title: "Version", value: appVersion)

                        Divider()
                            .padding(.leading, 16)

                        aboutRow(title: "Made with", value: "SwiftUI")
                    }
                }

                Text("© 2026 iPHTech 34. All rights reserved.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("About HRDesk")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func aboutRow(title: String, value: String) -> some View {

        HStack {

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color("textPrimary"))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}