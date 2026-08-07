//
//  ContentView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            CandidatesView()
                .tabItem {
                    Label("Candidates", systemImage: "person.2.fill")
                }

            EmployeesView()
                .tabItem {
                    Label("Employees", systemImage: "person.3.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(Color("textSecondary"))
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager())
}
