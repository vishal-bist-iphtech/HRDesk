//
//  CoreDataService.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import Foundation
import CoreData

final class CoreDataService {

    static let shared = CoreDataService()

    private let context: NSManagedObjectContext

    private init(
        context: NSManagedObjectContext =
            PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }


    private func saveContext() {

        guard context.hasChanges else {
            return
        }

        do {
            try context.save()
        } catch {
            print(
                "Core Data Save Error:",
                error.localizedDescription
            )
        }
    }

    // MARK: - Todo

    func fetchTodos() -> [TodoEntity] {

        let request: NSFetchRequest<TodoEntity> =
            TodoEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "dueDate",
                ascending: true
            )
        ]

        do {
            return try context.fetch(request)
        } catch {
            print(
                "Failed to fetch todos:",
                error.localizedDescription
            )

            return []
        }
    }

    func addTodo(
        title: String,
        dueDate: Date,
        priority: String
    ) {

        let todo = TodoEntity(context: context)

        todo.id = UUID()
        todo.title = title
        todo.dueDate = dueDate
        todo.priority = priority
        todo.isCompleted = false
        todo.createdAt = Date()

        saveContext()
    }

    func updateTodo(
        _ todo: TodoEntity,
        title: String,
        dueDate: Date,
        priority: String,
        isCompleted: Bool
    ) {

        todo.title = title
        todo.dueDate = dueDate
        todo.priority = priority
        todo.isCompleted = isCompleted

        saveContext()
    }

    func deleteTodo(_ todo: TodoEntity) {

        context.delete(todo)

        saveContext()
    }

    // MARK: - Jobs

    func addJob(
        title: String,
        department: String,
        location: String,
        employmentType: String,
        experience: String,
        salary: String,
        jobDescription: String
    ) {

        let job = JobEntity(context: context)

        job.id = UUID()
        job.title = title
        job.department = department
        job.location = location
        job.employmentType = employmentType
        job.experience = experience
        job.salaryRange = salary
        job.jd = jobDescription
        job.createdAt = Date()
        job.isActive = true

        saveContext()
    }

    func fetchJobs() -> [JobEntity] {

        let request: NSFetchRequest<JobEntity> =
            JobEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "createdAt",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request)
        } catch {
            print(
                "Failed to fetch jobs:",
                error.localizedDescription
            )

            return []
        }
    }

    func updateJob(
        _ job: JobEntity,
        title: String,
        department: String,
        location: String,
        employmentType: String,
        experience: String,
        salary: String,
        jobDescription: String
    ) {

        job.title = title
        job.department = department
        job.location = location
        job.employmentType = employmentType
        job.experience = experience
        job.salaryRange = salary
        job.jd = jobDescription

        saveContext()
    }

    func deleteJob(_ job: JobEntity) {

        context.delete(job)

        saveContext()
    }

    // MARK: - Employees

    func addEmployee(
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        department: String,
        position: String,
        joiningDate: Date,
        salary: Double
    ) {

        let employee = EmployeeEntity(context: context)

        employee.id = UUID()
        employee.firstName = firstName
        employee.lastName = lastName
        employee.email = email
        employee.phone = phone
        employee.department = department
        employee.position = position
        employee.joiningDate = joiningDate
        employee.salary = salary
        employee.createdAt = Date()

        saveContext()
    }

    func fetchEmployees() -> [EmployeeEntity] {

        let request: NSFetchRequest<EmployeeEntity> =
            EmployeeEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(
                key: "joiningDate",
                ascending: false
            )
        ]

        do {
            return try context.fetch(request)
        } catch {
            print(
                "Failed to fetch employees:",
                error.localizedDescription
            )

            return []
        }
    }
}
