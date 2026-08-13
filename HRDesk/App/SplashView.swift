//
//  SplashView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct SplashView: View {

    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var titleOpacity: Double = 0
    @State private var progress = 0.0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("background"), Color("background").opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.white.opacity(0.15))
                        .frame(width: 110, height: 110)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )

                    Image(systemName: "person.3.sequence.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(.white)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                Text("HRDesk")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)

                Text("Your HR Management Companion")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)

                Spacer()

                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .tint(.white)
                    .frame(width: 140)
                    .opacity(titleOpacity)

                Text("Loading...")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .opacity(titleOpacity)
                    .padding(.top, 4)
            }
            .padding(.bottom, 60)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.7).delay(0.3)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in

                    if progress < 0.7 {
                        progress += 0.02

                    } else if progress < 0.9 {
                        progress += 0.008

                    } else if progress < 0.98 {
                        progress += 0.002

                    } else {
                        progress = 1
                        timer.invalidate()
                    }
                }
        }
    }
}

#Preview {
    SplashView()
}
