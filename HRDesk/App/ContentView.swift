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
    @StateObject private var employeeViewModel = EmployeeViewModel()
    @StateObject private var interviewViewModel = InterviewViewModel()
    @StateObject private var candidateViewModel = CandidateViewModel()

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

                EmployeesView()
                    .tabItem {
                        Label("Employees", systemImage: "person.3.fill")
                    }
                
                AnalysisView()
                    .tabItem {
                        Label("Analysis", systemImage: "chart.pie")
                    }
            }
            .tint(Color("background"))
            .environmentObject(todoViewModel)
            .environmentObject(jobViewModel)
            .environmentObject(employeeViewModel)
            .environmentObject(interviewViewModel)
            .environmentObject(candidateViewModel)       
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager())
}
