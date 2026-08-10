//
//  EditTaskView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct EditTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var todoViewModel: TodoViewModel
    
    let todo: TodoEntity
    
    @State private var title: String
    @State private var dueDate: Date
    @State private var priority: TodoItem.Priority
    
    init(
        todo: TodoEntity
    ) {
        self.todo = todo
        
        _title = State(initialValue: todo.title ?? "")
        _dueDate = State(initialValue: todo.dueDate ?? Date())
        _priority = State(initialValue: TodoItem.Priority(rawValue: todo.priority ?? "Medium") ?? .medium)
    }
    
    var body: some View {
        
        Form {
            
            Section("Task") {
                TextField("Task title", text: $title)
                DatePicker("Due date", selection: $dueDate)
            }
            
            Section("Priority") {
                
                Picker("Priority", selection: $priority) {
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
                    updateTask()
                } label: {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("Edit Task")
        
    }
    
    private func updateTask() {
        todoViewModel.updateTodo(
            todo,
            title: title,
            dueDate: dueDate,
            priority: priority
        )
        
        dismiss()
    }
}

