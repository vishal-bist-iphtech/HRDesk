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

    @discardableResult
    func addTodo(
        title: String,
        dueDate: Date,
        priority: TodoItem.Priority,
        interviewID: UUID? = nil
    ) -> UUID? {

        let todo = coreDataService.addTodo(
            title: title,
            dueDate: dueDate,
            priority: priority.rawValue,
            interviewID: interviewID
        )

        fetchTodos()

        if let todo {
            NotificationService.shared.scheduleTodoNotification(for: todo)

            return todo.id
        }

        return nil
    }

    func updateTodo(
        _ todo: TodoEntity,
        title: String,
        dueDate: Date,
        priority: TodoItem.Priority
    ) {

        guard let id = todo.id else { return }

        coreDataService.updateTodo(
            todo,
            title: title,
            dueDate: dueDate,
            priority: priority.rawValue,
            isCompleted: todo.isCompleted
        )

        fetchTodos()

        if let updated = todos.first(where: { $0.id == id }) {
            syncNotification(for: updated)
        }
    }
    
    
    func deleteTodo(
        _ todo: TodoEntity
    ) {

        NotificationService.shared.cancelTodoNotification(for: todo)

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

        syncNotification(for: todo)
    }

    func setCompletion(
        _ todo: TodoEntity,
        isCompleted: Bool
    ) {

        guard todo.isCompleted != isCompleted else {
            return
        }

        coreDataService.updateTodo(
            todo,
            title: todo.title ?? "",
            dueDate: todo.dueDate ?? Date(),
            priority: todo.priority ?? TodoItem.Priority.medium.rawValue,
            isCompleted: isCompleted
        )

        fetchTodos()

        syncNotification(for: todo)
    }

    func todo(withInterviewID id: UUID?) -> TodoEntity? {

        guard let id else {
            return nil
        }

        return todos.first {
            $0.interviewID == id
        }
    }

    // MARK: - Notifications

    private func syncNotification(for todo: TodoEntity) {

        if todo.isCompleted {
            NotificationService.shared.cancelTodoNotification(for: todo)
        } else {
            NotificationService.shared.scheduleTodoNotification(for: todo)
        }
    }

}
