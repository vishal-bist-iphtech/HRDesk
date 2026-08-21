//
//  AvatarView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct AvatarView: View {

    let name: String
    var size: CGFloat = 48
    var showsMatchBadge = false

    private var initials: String {

        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }

    var body: some View {

        ZStack {

            Circle()
                .fill(Color("background").opacity(0.14))

            Text(initials)
                .font(.system(size: size * 0.32, weight: .semibold))
                .foregroundStyle(Color("background"))
        }
        .frame(width: size,height: size)
        .overlay(alignment: .bottomTrailing) {

            if showsMatchBadge {

                Image(systemName: "star.fill")
                    .font(.system(size: size * 0.2))
                    .foregroundStyle(.yellow)
                    .padding(size * 0.05)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        AvatarView(name: "Sophia Carter", size: 48)
        AvatarView(name: "Noah Williams", size: 72)
    }
}
