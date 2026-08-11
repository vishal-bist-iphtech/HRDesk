//
//  ContentView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var todoViewModel = TodoViewModel()
    @StateObject private var jobViewModel = JobViewModel()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            PipelineView()
                .tabItem {
                    Label("Pipeline", systemImage: "square.grid.2x2.fill")
                }

            JobsView()
                .tabItem {
                    Label("Jobs", systemImage: "briefcase.fill")
                }

            CandidatesView()
                .tabItem {
                    Label("Candidates", systemImage: "person.2.fill")
                }

            EmployeesView()
                .tabItem {
                    Label("Employees", systemImage: "person.3.fill")
                }
        }
        .tint(Color("textSecondary"))
        .environmentObject(todoViewModel)
        .environmentObject(jobViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager())
}
