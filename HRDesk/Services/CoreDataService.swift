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
            let nsError = error as NSError
            print(
                "Core Data Save Error:",
                nsError,
                nsError.userInfo
            )
        }
    }

    // MARK: ------------> Todo

    func fetchTodos() -> [TodoEntity] {

        let request: NSFetchRequest<TodoEntity> =
            TodoEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "dueDate",ascending: true)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch todos:",
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

    // MARK: -------------->  Jobs

    func addJob(
        title: String,
        department: String,
        location: String,
        employmentType: String,
        experience: String,
        salary: String,
        jobDescription: String,
        status: String = "Open"
    ) {

        let job = JobEntity(context: context)

        job.id = UUID()
        job.title = title.lowercased()
        job.department = department
        job.location = location
        job.employmentType = employmentType
        job.experience = experience
        job.salaryRange = salary
        job.jd = jobDescription
        job.status = status
        job.createdAt = Date()
        job.isActive = true

        saveContext()
    }

    func fetchJobs() -> [JobEntity] {

        let request: NSFetchRequest<JobEntity> = JobEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch jobs:",error.localizedDescription)

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
        jobDescription: String,
        status: String
    ) {

        job.title = title.lowercased()
        job.department = department
        job.location = location
        job.employmentType = employmentType
        job.experience = experience
        job.salaryRange = salary
        job.jd = jobDescription
        job.status = status

        saveContext()
    }

    func updateJobStatus(
        _ job: JobEntity,
        status: String
    ) {

        job.status = status

        saveContext()
    }

    func deleteJob(_ job: JobEntity) {

        context.delete(job)

        saveContext()
    }

    // MARK: - Employees

    func addEmployee(
        name: String,
        email: String,
        phone: String,
        department: String,
        position: String,
        joiningDate: Date,
        salary: Double
    ) {

        let employee = EmployeeEntity(context: context)

        employee.id = UUID()
        employee.name = name
        employee.email = email
        employee.phone = phone
        employee.department = department
        employee.position = position
        employee.joiningDate = joiningDate
        employee.salary = salary

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

    func deleteEmployee(_ employee: EmployeeEntity) {

        context.delete(employee)

        saveContext()
    }

    // MARK: - Interviews

    func addInterview(
        candidateID: UUID?,
        candidateName: String,
        candidateRole: String,
        interviewType: String,
        date: Date,
        duration: String,
        location: String,
        notes: String,
        interviewers: [Interviewer]
    ) {

        let interview = InterviewEntity(context: context)

        interview.id = UUID()
        interview.candidateID = candidateID
        interview.candidateName = candidateName
        interview.candidateRole = candidateRole
        interview.interviewType = interviewType
        interview.date = date
        interview.duration = duration
        interview.location = location
        interview.notes = notes
        interview.status = "Scheduled"
        interview.createdAt = Date()
        interview.interviewerNames = interviewers
            .map(\.name)
            .joined(separator: "|")
        interview.interviewerRoles = interviewers
            .map(\.role)
            .joined(separator: "|")

        saveContext()
    }

    func fetchInterviews() -> [InterviewEntity] {

        let request: NSFetchRequest<InterviewEntity> =
            InterviewEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print(
                "Failed to fetch interviews:",
                error.localizedDescription
            )

            return []
        }
    }

    func deleteInterview(id: UUID) {

        let request: NSFetchRequest<InterviewEntity> =
            InterviewEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        request.fetchLimit = 1

        guard let interview = try? context.fetch(request).first else {
            return
        }

        context.delete(interview)

        saveContext()
    }

    // MARK: - Auth

    func addUser(
        fullName: String,
        email: String,
        password: String
    ) -> UserEntity? {

        let request: NSFetchRequest<UserEntity> =
            UserEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "email ==[c] %@",
            email
        )

        if let existing = try? context.fetch(request).first {
            return existing
        }

        let user = UserEntity(context: context)

        user.id = UUID()
        user.fullName = fullName
        user.email = email
        user.password = password
        user.createdAt = Date()

        saveContext()

        return user
    }

    func authenticateUser(
        email: String,
        password: String
    ) -> UserEntity? {

        let request: NSFetchRequest<UserEntity> =
            UserEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "email ==[c] %@ AND password == %@",
            email,
            password
        )

        do {
            return try context.fetch(request).first
        } catch {
            print(
                "Failed to authenticate user:",
                error.localizedDescription
            )

            return nil
        }
    }

    // MARK: - Dashboard Counts

    func countActiveJobs() -> Int {

        let request: NSFetchRequest<JobEntity> =
            JobEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "isActive == YES"
        )

        do {
            return try context.count(for: request)
        } catch {
            print(
                "Failed to count active jobs:",
                error.localizedDescription
            )

            return 0
        }
    }

    func fetchCandidates() -> [CandidateEntity] {

        let request: NSFetchRequest<CandidateEntity> =
            CandidateEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "appliedDate",ascending: false)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch candidates:",
                error.localizedDescription
            )

            return []
        }
    }

    func countCandidates() -> Int {

        let request: NSFetchRequest<CandidateEntity> =
            CandidateEntity.fetchRequest()

        do {
            return try context.count(for: request)
        } catch {
            print(
                "Failed to count candidates:",
                error.localizedDescription
            )

            return 0
        }
    }

    func countHiredCandidates() -> Int {

        let request: NSFetchRequest<CandidateEntity> =
            CandidateEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "status ==[c] %@",
            "hired"
        )

        do {
            return try context.count(for: request)
        } catch {
            print(
                "Failed to count hired candidates:",
                error.localizedDescription
            )

            return 0
        }
    }

    // MARK: ----------->  Candidates

    func addCandidate(
        fullName: String,
        role: String,
        email: String,
        phone: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
        appliedDate: String,
        noticePeriod: String,
        expectedSalary: String,
        about: String,
        location: String,
        website: String?,
        resume: Data?,
        job: JobEntity?
    ) {

        let candidate = CandidateEntity(context: context)

        candidate.id = UUID()
        candidate.fullName = fullName
        candidate.role = role
        candidate.email = email
        candidate.phone = phone
        candidate.status = stage.rawValue
        candidate.experience = experience
        candidate.matchScore = Int64(matchScore)
        candidate.appliedDate = appliedDate
        candidate.noticePeriod = noticePeriod
        candidate.expectedSalary = expectedSalary
        candidate.about = about
        candidate.location = location
        candidate.website = website
        candidate.job = job ?? matchingJob(for: role)
        candidate.resumeData = resume ?? Data()

        saveContext()
    }

    func updateCandidate(
        id: UUID,
        fullName: String,
        role: String,
        email: String,
        phone: String,
        stage: PipelineStage,
        experience: String,
        matchScore: Int,
        appliedDate: String,
        noticePeriod: String,
        expectedSalary: String,
        about: String,
        location: String,
        website: String?,
        resume: Data?
    ) {

        guard let candidate = candidate(withID: id) else {
            return
        }

        candidate.fullName = fullName
        candidate.role = role
        candidate.email = email
        candidate.phone = phone
        candidate.status = stage.rawValue
        candidate.experience = experience
        candidate.matchScore = Int64(matchScore)
        candidate.appliedDate = appliedDate
        candidate.noticePeriod = noticePeriod
        candidate.expectedSalary = expectedSalary
        candidate.about = about
        candidate.location = location
        candidate.website = website
        candidate.resumeData = resume ?? candidate.resumeData

        saveContext()
    }

    func updateCandidateStage(
        id: UUID,
        stage: PipelineStage
    ) {

        guard let candidate = candidate(withID: id) else {
            return
        }

        candidate.status = stage.rawValue

        saveContext()
    }

    func deleteCandidate(id: UUID) {

        guard let candidate = candidate(withID: id) else {
            return
        }

        context.delete(candidate)

        saveContext()
    }

    private func matchingJob(for role: String) -> JobEntity? {

        let trimmedRole = role.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).lowercased()

        guard !trimmedRole.isEmpty else {
            return nil
        }

        let request: NSFetchRequest<JobEntity> =
            JobEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "title ==[c] %@",
            trimmedRole
        )

        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to find matching job:",
                error.localizedDescription
            )

            return nil
        }
    }

    private func candidate(withID id: UUID) -> CandidateEntity? {

        let request: NSFetchRequest<CandidateEntity> =
            CandidateEntity.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )

        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            print(
                "Failed to find candidate:",
                error.localizedDescription
            )

            return nil
        }
    }

}
