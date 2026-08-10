//
//  TodoListView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct TodoListView: View {

    @ObservedObject var todoViewModel: TodoViewModel

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

                    AddTaskView(
                        todoViewModel: todoViewModel
                    )

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

                    todoViewModel.toggleCompletion(todo)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    Color.clear
                )
            }
            .onDelete { indexSet in

                for index in indexSet {

                    todoViewModel.deleteTodo(
                        todoViewModel.todos[index]
                    )
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {

    NavigationStack {

        TodoListView(
            todoViewModel: TodoViewModel()
        )
    }
}
