//
//  TodoTask.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import Foundation

struct TodoTask: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: String
    var priority: TodoItem.Priority
    var isCompleted: Bool
}
