//
//  TodoListView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct TodoListView: View {

    @EnvironmentObject private var todoViewModel: TodoViewModel
    @EnvironmentObject private var interviewViewModel: InterviewViewModel

    var body: some View {

        Group {

            if todoViewModel.todos.isEmpty {

                ContentUnavailableView(
                    "No Tasks Yet",
                    systemImage: "checklist",
                    description: Text(
                        "You don't have any tasks yet. Add a task to keep your work organized."
                    )
                )

            } else {

                todoList
            }
        }
        .navigationTitle("Todo List")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {

            ToolbarItem(
                placement: .topBarTrailing
            ) {

                NavigationLink {

                    AddTaskView()

                } label: {

                    Image(systemName: "plus")
                }
            }
        }
    }

    private var todoList: some View {

        List {

            ForEach(todoViewModel.todos) { todo in

                TodoItem(
                    todo: todo
                ) {

                    toggleTodo(todo)
                }
                .swipeActions(
                    edge: .trailing,
                    allowsFullSwipe: false
                ) {

                    Button(
                        role: .destructive
                    ) {

                        deleteTodo(todo)

                    } label: {

                        Label(
                            "Delete",
                            systemImage: "trash"
                        )
                    }

                    NavigationLink {

                        EditTaskView(
                            todo: todo
                        )

                    } label: {

                        Label(
                            "Edit",
                            systemImage: "pencil"
                        )
                    }
                    .tint(.orange)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    Color.clear
                )
            }
        }
        .listStyle(.plain)
    }
    
    private func deleteTodo(
        _ todo: TodoEntity
    ) {

        todoViewModel.deleteTodo(todo)
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

    NavigationStack {

        TodoListView()
            .environmentObject(TodoViewModel())
            .environmentObject(InterviewViewModel())
    }
}
