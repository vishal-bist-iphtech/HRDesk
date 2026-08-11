//
//  HomeView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var session: SessionManager
    
    @EnvironmentObject var todoViewModel: TodoViewModel
    @EnvironmentObject var jobViewModel: JobViewModel

    @StateObject private var dashboardViewModel = DashboardViewModel()

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        default: return "Good Evening,"
        }
    }

    private var userName: String {
        session.currentUser?.fullName ?? "Vishal"
    }

    private var stats: [(icon: String, title: String, value: String, tint: Color)] {
        [
            ("briefcase.fill", "Open Jobs", "\(dashboardViewModel.openJobs)", Color("textSecondary")),
            ("person.2.fill", "Applied", "\(dashboardViewModel.applications)", .orange),
            ("checkmark.circle.fill", "Interviews", "\(dashboardViewModel.interviewsToday)", .green),
            ("person.crop.circle.badge.checkmark", "Hired", "\(dashboardViewModel.hiredCandidates)", .purple)
        ]
    }

    var body: some View {
        NavigationStack {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 24) {
                        header
                        Spacer()
                        statsGrid
                        quickActions
                        todoList
                    }
                    .padding()
                }
        }
        .onAppear {
            dashboardViewModel.refresh()
        }
    }

    private var header: some View {
       
        HStack(spacing: 10){
            HStack(alignment: .center, spacing: 12) {
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title.bold())
                        .foregroundStyle(Color("textPrimary").opacity(0.6))
                }
                
            
                VStack(alignment: .leading, spacing:0) {
                    HStack{
                        Text(greeting)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text(userName)
                            .font(.title3.bold())
                            .foregroundStyle(Color("textPrimary"))
                    }
                    
                    
                    Text("Today's hiring activity at a glance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            
            Image(systemName: "bell.badge")
                .font(.title)
                   .foregroundStyle(.primary)
                   .symbolRenderingMode(.palette)
                   .foregroundStyle(.red, .primary)
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(stats.enumerated()), id: \.offset) { _, stat in
                StatCard(icon: stat.icon, title: stat.title, value: stat.value, tint: stat.tint)
            }
            
        }
    }

    private var quickActions: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Quick Actions")
                .font(.headline)
                .foregroundStyle(Color("textPrimary"))

            HStack(spacing: 14) {

                NavigationLink {
                    AddJobView()
                } label: {

                    quickActionContent(
                        icon: "plus.circle.fill",
                        title: "Post a Job",
                        tint: Color("textSecondary")
                    )
                }

                NavigationLink {
                    AddEmployeeView()
                } label: {

                    quickActionContent(
                        icon: "doc.badge.plus",
                        title: "New Employee",
                        tint: .green
                    )
                }

                Button {
                } label: {

                    quickActionContent(
                        icon: "calendar.badge.plus",
                        title: "Schedule",
                        tint: .orange
                    )
                }
            }
        }
    }

    private func quickActionContent(
        icon: String,
        title: String,
        tint: Color
    ) -> some View {

        VStack(spacing: 10) {

            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(tint)

            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(Color("textPrimary"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.gray.opacity(0.06))
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
    }

   
    
    private var todoList: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            // MARK: Header

            HStack {

                Text("Todo List")
                    .font(.headline)
                    .foregroundStyle(
                        Color("textPrimary")
                    )

                Spacer()

                if todoViewModel.todos.count <= 4 {

                    NavigationLink {

                        AddTaskView()

                    } label: {
                        
                        Text("Add")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                Color("textSecondary")
                            )
                        Image(systemName: "plus")
                            .font(
                                .system(
                                    size: 16,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                Color("textSecondary")
                            )
                        
                    }

                } else {

                    NavigationLink {

                        TodoListView()

                    } label: {

                        Text("See all")
                            .font(
                                .subheadline.weight(.semibold)
                            )
                            .foregroundStyle(
                                Color("textSecondary")
                            )
                    }
                }
            }

            // MARK: Content

            if todoViewModel.todos.isEmpty {

                ContentUnavailableView(
                    "No Tasks Yet",
                    systemImage: "checklist",
                    description: Text(
                        "You don't have any tasks yet. Add a task to keep your work organized."
                    )
                )
                .frame(
                    maxWidth: .infinity,
                    minHeight: 180
                )

            } else {

                VStack(spacing: 10) {

                    ForEach(
                        Array(
                            todoViewModel.todos
                                .prefix(5)
                        )
                    ) { todo in

                        TodoItem(
                            todo: todo
                        ) {

                            todoViewModel
                                .toggleCompletion(todo)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SessionManager())
        .environmentObject(AuthViewModel())
        .environmentObject(TodoViewModel())
        .environmentObject(JobViewModel())
}
