//
//  ScoreRing.swift
//  HRDesk
//
//  Created by iPHTech 34 on 11/08/26.
//

import SwiftUI

struct ScoreRing: View {

    let score: Int
    var size: CGFloat = 46
    var lineWidth: CGFloat = 3.5
    var showsPercent = false

    private var color: Color {
        
        if score >= 95 {
            return .green
        }

        if score >= 85 {
            return .green.opacity(0.9)
        }

        if score >= 70 {
            return .green.opacity(0.7)
        }
        
        if score >= 60{
            return .orange
        }
        return .red
    }

    var body: some View {

        ZStack {

            Circle()
                .stroke(
                    color.opacity(0.18),
                    lineWidth: lineWidth
                )

            Circle()
                .trim(
                    from: 0,
                    to: min(CGFloat(score) / 100, 1)
                )
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            if showsPercent {
                VStack(spacing: 0){
                    
                    Text("\(score)%")
                        .font(
                            .system(size: size * 0.30, weight: .bold)
                        )
                    
                    Text("Match")
                    .font(.system(size: size * 0.20, weight: .bold))
                }                
                .foregroundStyle(color)
            } else {

                VStack(spacing: 0) {

                    Text("\(score)")
                        .font(
                            .system(size: size * 0.34, weight: .bold)
                        )

                    Text("Match")
                        .font(
                            .system(size: size * 0.16)
                        )
                }
                .foregroundStyle(color)
            }
        }
        .frame(
            width: size,
            height: size
        )
    }
}

#Preview {
    HStack(spacing: 16) {
        ScoreRing(score: 95)
        ScoreRing(score: 76)
        ScoreRing(score: 68)
        ScoreRing(score: 95, size: 64, lineWidth: 4, showsPercent: true)
    }
}
