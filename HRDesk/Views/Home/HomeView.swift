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
    @EnvironmentObject var interviewViewModel: InterviewViewModel

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
            (
                 "briefcase.fill",
                 "Open Jobs",
                 "\(dashboardViewModel.openJobs)",
                 Color("background")
            ),
            (
                "person.2.fill",
                "Applied",
                "\(dashboardViewModel.applications)",
                .orange
            ),
            (
                "checkmark.circle.fill",
                "Interviews",
                "\(dashboardViewModel.interviewsToday)",
                .green
            ),
            (
                "person.crop.circle.badge.checkmark",
                "Hired",
                "\(dashboardViewModel.hiredCandidates)",
                .purple
            )
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
            interviewViewModel.fetchInterviews()
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
                        .foregroundStyle(Color("textPrimary").opacity(0.8))
                }
                
            
                VStack(alignment: .leading, spacing:0) {
                    HStack{
                        Text(greeting)
                            .font(.title3)
                            .foregroundStyle(Color("textPrimary").opacity(0.7))
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
                statCardDestination(stat: stat)
            }
        }
    }

    private func statCardDestination(stat: (icon: String, title: String, value: String, tint: Color)) -> some View {
        NavigationLink {
            switch stat.title {
            case "Interviews":
                UpcomingInterviewsView()
            default:
                UpcomingInterviewsView()
            }
        } label: {
            StatCard(
                icon: stat.icon,
                title: stat.title,
                value: stat.value,
                tint: stat.tint
            )
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
                        tint: Color("background")
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

                NavigationLink {
                    UpcomingInterviewsView()
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
        .background(Color.gray.opacity(0.08))
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
    }
    

    private var upcomingInterviewList: [InterviewEntity] {

        let startOfDay = Calendar.current.startOfDay(for: Date())

        return interviewViewModel.interviews
            .filter {

                ($0.status ?? "Scheduled") != "Done"
                && ($0.date ?? .distantPast) >= startOfDay
            }
            .sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }

    private var todoList: some View {

        VStack(alignment: .leading,spacing: 12) {

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
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundStyle(Color("textPrimary"))
                        Image(systemName: "plus")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundStyle(Color("textPrimary"))
                        
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
                                Color("textPrimary")
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
                .frame(maxWidth: .infinity, minHeight: 180)

            } else {

                VStack(spacing: 10) {

                    ForEach(
                        Array(todoViewModel.todos.prefix(5))
                    ) { todo in

                        TodoItem(
                            todo: todo
                        ) {

                            toggleTodo(todo)
                        }
                    }
                }
            }
        }
    }

    private func toggleTodo(_ todo: TodoEntity) {

        let willComplete = !todo.isCompleted

        todoViewModel.toggleCompletion(todo)

        if let interviewID = todo.interviewID {
            interviewViewModel.setDone(
                interviewID: interviewID,
                done: willComplete
            )
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SessionManager())
        .environmentObject(AuthViewModel())
        .environmentObject(TodoViewModel())
        .environmentObject(JobViewModel())
        .environmentObject(InterviewViewModel())
}
