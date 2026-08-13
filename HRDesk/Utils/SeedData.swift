//
//  SeedData.swift
//  HRDesk
//
//  Created by iPHTech 34 on 13/08/26.
//

import Foundation
import CoreData

enum SeedData {

    private struct SeedJob {
        let title: String
        let department: String
        let location: String
        let employmentType: String
        let experience: String
        let salaryRange: String
        let jobDescription: String
        let status: String
    }

    private struct SeedCandidate {
        let name: String
        let role: String
        let stage: PipelineStage
        let experience: String
        let matchScore: Int
        let email: String
        let phone: String
        let appliedDate: String
        let noticePeriod: String
        let expectedSalary: String
        let jobIndex: Int
    }

    private struct SeedEmployee {
        let firstName: String
        let lastName: String
        let email: String
        let phone: String
        let department: String
        let position: String
        let joiningDate: Date
        let salary: Double
    }

    private static let jobs: [SeedJob] = [
        SeedJob(
            title: "Senior iOS Engineer",
            department: "Engineering",
            location: "Bengaluru",
            employmentType: "Full Time",
            experience: "5-8 Years",
            salaryRange: "₹25-35 LPA",
            jobDescription: "Build and scale HRDesk's iOS app using Swift, SwiftUI and Core Data. Mentor junior engineers and lead architecture decisions for the mobile platform.",
            status: "Open"
        ),
        SeedJob(
            title: "Product Designer",
            department: "Design",
            location: "Remote",
            employmentType: "Contract",
            experience: "3-6 Years",
            salaryRange: "₹15-22 LPA",
            jobDescription: "Design intuitive hiring workflows, own the end-to-end UX of the candidate pipeline, and collaborate closely with product and engineering.",
            status: "Open"
        ),
        SeedJob(
            title: "Backend Developer",
            department: "Engineering",
            location: "Gurugram",
            employmentType: "Full Time",
            experience: "4-7 Years",
            salaryRange: "₹20-30 LPA",
            jobDescription: "Design and maintain scalable APIs for the HRDesk platform. Experience with Node.js, PostgreSQL and cloud infrastructure is required.",
            status: "On Hold"
        ),
        SeedJob(
            title: "Growth Marketing Manager",
            department: "Marketing",
            location: "Mumbai",
            employmentType: "Internship",
            experience: "0-1 Years",
            salaryRange: "₹4-6 LPA",
            jobDescription: "Drive user acquisition and retention for HRDesk. Own life-cycle campaigns, SEO, and partnership initiatives across channels.",
            status: "Closed"
        )
    ]

    private static let candidates: [SeedCandidate] = [
        SeedCandidate(name: "Sophia Carter", role: "iOS Engineer", stage: .interview, experience: "6 Yrs Exp", matchScore: 92, email: "sophia@gmail.com", phone: "+91 98450 12001", appliedDate: "2 days ago", noticePeriod: "30 Days", expectedSalary: "₹28 LPA", jobIndex: 0),
        SeedCandidate(name: "Aarav Mehta", role: "iOS Engineer", stage: .screening, experience: "5 Yrs Exp", matchScore: 84, email: "aarav.mehta@gmail.com", phone: "+91 98450 12002", appliedDate: "3 days ago", noticePeriod: "60 Days", expectedSalary: "₹25 LPA", jobIndex: 0),
        SeedCandidate(name: "Emily Johnson", role: "iOS Engineer", stage: .offer, experience: "7 Yrs Exp", matchScore: 95, email: "emily.j@gmail.com", phone: "+91 98450 12003", appliedDate: "1 week ago", noticePeriod: "Immediate", expectedSalary: "₹32 LPA", jobIndex: 0),
        SeedCandidate(name: "Rohan Kumar", role: "iOS Engineer", stage: .rejected, experience: "3 Yrs Exp", matchScore: 55, email: "rohan.k@gmail.com", phone: "+91 98450 12004", appliedDate: "5 days ago", noticePeriod: "90 Days", expectedSalary: "₹18 LPA", jobIndex: 0),
        SeedCandidate(name: "Olivia Brown", role: "iOS Engineer", stage: .applied, experience: "4 Yrs Exp", matchScore: 78, email: "olivia.b@gmail.com", phone: "+91 98450 12005", appliedDate: "2 days ago", noticePeriod: "45 Days", expectedSalary: "₹22 LPA", jobIndex: 0),
        SeedCandidate(name: "Liam Wilson", role: "Product Designer", stage: .interview, experience: "5 Yrs Exp", matchScore: 88, email: "liam.w@gmail.com", phone: "+91 98450 12006", appliedDate: "4 days ago", noticePeriod: "30 Days", expectedSalary: "₹20 LPA", jobIndex: 1),
        SeedCandidate(name: "Priya Sharma", role: "Product Designer", stage: .screening, experience: "3 Yrs Exp", matchScore: 81, email: "priya.s@gmail.com", phone: "+91 98450 12007", appliedDate: "1 day ago", noticePeriod: "Immediate", expectedSalary: "₹17 LPA", jobIndex: 1),
        SeedCandidate(name: "Noah Davis", role: "Product Designer", stage: .applied, experience: "2 Yrs Exp", matchScore: 68, email: "noah.d@gmail.com", phone: "+91 98450 12008", appliedDate: "6 days ago", noticePeriod: "60 Days", expectedSalary: "₹15 LPA", jobIndex: 1),
        SeedCandidate(name: "Ananya Verma", role: "Product Designer", stage: .hired, experience: "6 Yrs Exp", matchScore: 97, email: "ananya.v@gmail.com", phone: "+91 98450 12009", appliedDate: "2 weeks ago", noticePeriod: "15 Days", expectedSalary: "₹23 LPA", jobIndex: 1),
        SeedCandidate(name: "Ava Martinez", role: "Product Designer", stage: .rejected, experience: "1 Yrs Exp", matchScore: 42, email: "ava.m@gmail.com", phone: "+91 98450 12010", appliedDate: "3 days ago", noticePeriod: "30 Days", expectedSalary: "₹12 LPA", jobIndex: 1),
        SeedCandidate(name: "Ishaan Gupta", role: "Backend Developer", stage: .interview, experience: "6 Yrs Exp", matchScore: 90, email: "ishaan.g@gmail.com", phone: "+91 98450 12011", appliedDate: "5 days ago", noticePeriod: "45 Days", expectedSalary: "₹27 LPA", jobIndex: 2),
        SeedCandidate(name: "Mia Thompson", role: "Backend Developer", stage: .applied, experience: "4 Yrs Exp", matchScore: 74, email: "mia.t@gmail.com", phone: "+91 98450 12012", appliedDate: "2 days ago", noticePeriod: "Immediate", expectedSalary: "₹21 LPA", jobIndex: 2),
        SeedCandidate(name: "Vikram Singh", role: "Backend Developer", stage: .screening, experience: "5 Yrs Exp", matchScore: 86, email: "vikram.s@gmail.com", phone: "+91 98450 12013", appliedDate: "7 days ago", noticePeriod: "30 Days", expectedSalary: "₹24 LPA", jobIndex: 2),
        SeedCandidate(name: "Charlotte Lee", role: "Backend Developer", stage: .offer, experience: "7 Yrs Exp", matchScore: 93, email: "charlotte.l@gmail.com", phone: "+91 98450 12014", appliedDate: "1 week ago", noticePeriod: "60 Days", expectedSalary: "₹30 LPA", jobIndex: 2),
        SeedCandidate(name: "Arjun Nair", role: "Backend Developer", stage: .rejected, experience: "2 Yrs Exp", matchScore: 49, email: "arjun.n@gmail.com", phone: "+91 98450 12015", appliedDate: "4 days ago", noticePeriod: "15 Days", expectedSalary: "₹16 LPA", jobIndex: 2),
        SeedCandidate(name: "Emma Garcia", role: "Growth Marketing", stage: .applied, experience: "0 Yrs Exp", matchScore: 61, email: "emma.g@gmail.com", phone: "+91 98450 12016", appliedDate: "1 day ago", noticePeriod: "Immediate", expectedSalary: "₹5 LPA", jobIndex: 3),
        SeedCandidate(name: "Kabir Malhotra", role: "Growth Marketing", stage: .screening, experience: "1 Yrs Exp", matchScore: 72, email: "kabir.m@gmail.com", phone: "+91 98450 12017", appliedDate: "3 days ago", noticePeriod: "30 Days", expectedSalary: "₹6 LPA", jobIndex: 3),
        SeedCandidate(name: "Aria Patel", role: "Growth Marketing", stage: .interview, experience: "1 Yrs Exp", matchScore: 79, email: "aria.p@gmail.com", phone: "+91 98450 12018", appliedDate: "6 days ago", noticePeriod: "15 Days", expectedSalary: "₹5 LPA", jobIndex: 3),
        SeedCandidate(name: "Ethan Moore", role: "Growth Marketing", stage: .rejected, experience: "0 Yrs Exp", matchScore: 38, email: "ethan.m@gmail.com", phone: "+91 98450 12019", appliedDate: "2 days ago", noticePeriod: "Immediate", expectedSalary: "₹4 LPA", jobIndex: 3),
        SeedCandidate(name: "Zara Khan", role: "Growth Marketing", stage: .hired, experience: "1 Yrs Exp", matchScore: 91, email: "zara.k@gmail.com", phone: "+91 98450 12020", appliedDate: "2 weeks ago", noticePeriod: "7 Days", expectedSalary: "₹7 LPA", jobIndex: 3)
    ]

    private static let employees: [SeedEmployee] = [
        SeedEmployee(firstName: "James", lastName: "Wilson", email: "james.wilson@hrdesk.com", phone: "+91 98450 13001", department: "Engineering", position: "Engineering Manager", joiningDate: date(2021, 3, 15), salary: 3200000),
        SeedEmployee(firstName: "Nina", lastName: "Rodriguez", email: "nina.rodriguez@hrdesk.com", phone: "+91 98450 13002", department: "People Operations", position: "People Operations Lead", joiningDate: date(2021, 6, 1), salary: 1800000),
        SeedEmployee(firstName: "Akshay", lastName: "Verma", email: "akshay.verma@hrdesk.com", phone: "+91 98450 13003", department: "Analytics", position: "Senior Data Analyst", joiningDate: date(2022, 1, 10), salary: 2100000),
        SeedEmployee(firstName: "Meera", lastName: "Iyer", email: "meera.iyer@hrdesk.com", phone: "+91 98450 13004", department: "Engineering", position: "iOS Engineer", joiningDate: date(2022, 5, 20), salary: 1900000),
        SeedEmployee(firstName: "Daniel", lastName: "Brown", email: "daniel.brown@hrdesk.com", phone: "+91 98450 13005", department: "Sales", position: "Account Executive", joiningDate: date(2022, 9, 5), salary: 1450000),
        SeedEmployee(firstName: "Sneha", lastName: "Kapoor", email: "sneha.kapoor@hrdesk.com", phone: "+91 98450 13006", department: "Marketing", position: "Marketing Manager", joiningDate: date(2023, 2, 14), salary: 1600000),
        SeedEmployee(firstName: "Rahul", lastName: "Sharma", email: "rahul.sharma@hrdesk.com", phone: "+91 98450 13007", department: "Engineering", position: "Backend Engineer", joiningDate: date(2023, 4, 22), salary: 1750000),
        SeedEmployee(firstName: "Emma", lastName: "Taylor", email: "emma.taylor@hrdesk.com", phone: "+91 98450 13008", department: "Design", position: "Product Designer", joiningDate: date(2023, 7, 30), salary: 1550000),
        SeedEmployee(firstName: "Arjun", lastName: "Reddy", email: "arjun.reddy@hrdesk.com", phone: "+91 98450 13009", department: "Finance", position: "Finance Analyst", joiningDate: date(2024, 1, 8), salary: 1250000),
        SeedEmployee(firstName: "Laura", lastName: "Kim", email: "laura.kim@hrdesk.com", phone: "+91 98450 13010", department: "Human Resources", position: "HR Generalist", joiningDate: date(2024, 3, 18), salary: 1150000)
    ]

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return Calendar.current.date(from: components) ?? Date()
    }

    static func seedIfNeeded(in context: NSManagedObjectContext) {

        var didInsert = false

        let jobsRequest: NSFetchRequest<JobEntity> = JobEntity.fetchRequest()
        jobsRequest.fetchLimit = 1

        if ((try? context.count(for: jobsRequest)) ?? 0) == 0 {

            var createdJobs: [JobEntity] = []

            for jobData in jobs {

                let job = JobEntity(context: context)
                job.id = UUID()
                job.title = jobData.title
                job.department = jobData.department
                job.location = jobData.location
                job.employmentType = jobData.employmentType
                job.experience = jobData.experience
                job.salaryRange = jobData.salaryRange
                job.jd = jobData.jobDescription
                job.status = jobData.status
                job.createdAt = Date()
                job.isActive = true

                createdJobs.append(job)
            }

            for candidateData in candidates {

                guard createdJobs.indices.contains(candidateData.jobIndex) else {
                    continue
                }

                let candidate = CandidateEntity(context: context)
                candidate.id = UUID()
                candidate.fullName = candidateData.name
                candidate.role = candidateData.role
                candidate.email = candidateData.email
                candidate.phone = candidateData.phone
                candidate.status = candidateData.stage.rawValue
                candidate.experience = candidateData.experience
                candidate.matchScore = Int64(candidateData.matchScore)
                candidate.appliedDate = candidateData.appliedDate
                candidate.noticePeriod = candidateData.noticePeriod
                candidate.expectedSalary = candidateData.expectedSalary
                candidate.createdAt = Date()
                candidate.resumeData = Data()
                candidate.job = createdJobs[candidateData.jobIndex]
            }

            didInsert = true
        }

        let employeesRequest: NSFetchRequest<EmployeeEntity> = EmployeeEntity.fetchRequest()
        employeesRequest.fetchLimit = 1

        if ((try? context.count(for: employeesRequest)) ?? 0) == 0 {

            for employeeData in employees {

                let employee = EmployeeEntity(context: context)
                employee.id = UUID()
                employee.firstName = employeeData.firstName
                employee.lastName = employeeData.lastName
                employee.email = employeeData.email
                employee.phone = employeeData.phone
                employee.department = employeeData.department
                employee.position = employeeData.position
                employee.joiningDate = employeeData.joiningDate
                employee.salary = employeeData.salary
                employee.createdAt = Date()
            }

            didInsert = true
        }

        guard didInsert else {
            return
        }

        do {
            try context.save()
        } catch {
            print(
                "Failed to seed data:",
                error.localizedDescription
            )
        }
    }
}