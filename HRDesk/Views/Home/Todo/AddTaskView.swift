//
//  AddTaskView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct AddTaskView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var todoViewModel: TodoViewModel

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var priority: TodoItem.Priority = .medium

    var body: some View {

        Form {

            Section("Task") {

                TextField(
                    "Task title",
                    text: $title
                )

                DatePicker(
                    "Due Date",
                    selection: $dueDate
                )
            }

            Section("Priority") {

                Picker(
                    "Priority",
                    selection: $priority
                ) {

                    Text("High")
                        .tag(TodoItem.Priority.high)

                    Text("Medium")
                        .tag(TodoItem.Priority.medium)

                    Text("Low")
                        .tag(TodoItem.Priority.low)
                }
                .pickerStyle(.segmented)
            }

            Section {

                Button {

                    todoViewModel.addTodo(
                        title: title,
                        dueDate: dueDate,
                        priority: priority
                    )

                    dismiss()

                } label: {

                    Text("Add Task")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(
                    title
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                )
            }
        }
        .navigationTitle("Add Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}
