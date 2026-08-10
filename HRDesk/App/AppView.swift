//
//  AppView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct AppView: View {

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    hero
                    features
                    buttons
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 32)
            }
            .background(Color("background").ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var hero: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("textSecondary"))
                    .frame(width: 96, height: 96)
                    .shadow(color: Color("textSecondary").opacity(0.4), radius: 16, y: 8)

                Image(systemName: "person.3.sequence.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(.white)
            }

            Text("Welcome to HRDesk")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color("textPrimary"))

            Text("Hire top talent with confidence")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color("textPrimary"))

            Text("Simply recruit, monitor progress, and grow exceptional teams.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var features: some View {
        VStack(spacing: 14) {
            FeatureRow(icon: "doc.text.magnifyingglass", title: "Smart Recruiting", subtitle: "Post jobs and manage candidates in one place")
            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Progress Tracking", subtitle: "Monitor hiring pipelines in real time")
            FeatureRow(icon: "person.3.sequence", title: "Team Growth", subtitle: "Build and manage exceptional teams")
        }
        .padding(.top, 8)
    }

    private var buttons: some View {
        VStack(spacing: 14) {
            NavigationLink {
                LoginView()
            } label: {
                HStack {
                    Text("Login")
                        .font(.title3.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color("textSecondary"), lineWidth: 1.5)
                        )
                }
                .foregroundStyle(.white)
                .background(Color("textSecondary"))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            NavigationLink {
                SignupView()
            } label: {
                Text("Create new account")
                    .font(.headline)
                    .foregroundStyle(Color("textSecondary"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("textSecondary"), lineWidth: 1.5)
                    )
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    AppView()
}
