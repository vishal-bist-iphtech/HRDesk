//
//  AvatarView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct AvatarView: View {

    let candidate: Candidate
    var size: CGFloat = 48
    var showFavoriteBadge = false

    var body: some View {

        ZStack(alignment: .bottomTrailing) {

            AsyncImage(
                url: URL(string: candidate.avatarURL)
            ) { phase in

                switch phase {

                case .success(let image):

                    image
                        .resizable()
                        .scaledToFill()

                case .failure, .empty:

                    fallback

                @unknown default:

                    fallback
                }
            }
            .frame(
                width: size,
                height: size
            )
            .clipShape(Circle())

            if showFavoriteBadge,
               candidate.isFavorite {

                Image(systemName: "star.fill")
                    .font(
                        .system(size: size * 0.22, weight: .bold)
                    )
                    .foregroundStyle(.yellow)
                    .background(
                        Circle()
                            .fill(.white)
                            .frame(
                                width: size * 0.34,
                                height: size * 0.34
                            )
                    )
                    .offset(
                        x: size * 0.05,
                        y: size * 0.05
                    )
            }
        }
        .frame(
            width: size,
            height: size
        )
    }

    private var fallback: some View {

        ZStack {

            Circle()
                .fill(
                    Color("textSecondary")
                        .opacity(0.14)
                )

            Text(candidate.initials)
                .font(
                    .system(size: size * 0.32, weight: .semibold)
                )
                .foregroundStyle(
                    Color("textSecondary")
                )
        }
    }
}

#Preview {
    AvatarView(
        candidate: Candidate.samples[0],
        size: 72,
        showFavoriteBadge: true
    )
}
