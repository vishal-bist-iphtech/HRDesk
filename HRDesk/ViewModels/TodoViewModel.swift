//
//  TodoViewModel.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import Foundation
import Combine
import CoreData

final class TodoViewModel: ObservableObject {

    @Published var todos: [TodoEntity] = []

    private let coreDataService = CoreDataService.shared

    init() {
        fetchTodos()
    }

    // MARK: - Fetch

    func fetchTodos() {

        todos = coreDataService.fetchTodos()
    }

    // MARK: - Add

    func addTodo(
        title: String,
        dueDate: Date,
        priority: TodoItem.Priority
    ) {

        coreDataService.addTodo(
            title: title,
            dueDate: dueDate,
            priority: priority.rawValue
        )

        fetchTodos()
    }

    func updateTodo(
        _ todo: TodoEntity,
        title: String,
        dueDate: Date,
        priority: TodoItem.Priority
    ) {

        coreDataService.updateTodo(
            todo,
            title: title,
            dueDate: dueDate,
            priority: priority.rawValue,
            isCompleted: todo.isCompleted
        )

        fetchTodos()
    }
    
    
    func deleteTodo(
        _ todo: TodoEntity
    ) {

        coreDataService.deleteTodo(todo)

        fetchTodos()
    }
    

    
    func toggleCompletion(
        _ todo: TodoEntity
    ) {

        coreDataService.updateTodo(
            todo,
            title: todo.title ?? "",
            dueDate: todo.dueDate ?? Date(),
            priority: todo.priority ?? TodoItem.Priority.medium.rawValue,
            isCompleted: !todo.isCompleted
        )

        fetchTodos()
    }

}
