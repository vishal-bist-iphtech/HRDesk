//
//  EmployeesView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI
import CoreData

struct EmployeesView: View {

    @EnvironmentObject private var employeeViewModel: EmployeeViewModel

    @State private var showAddEmployee = false
    @State private var showingDeleteFor: EmployeeEntity?
    @State private var searchText = ""

    private var filteredEmployees: [EmployeeEntity] {

        guard !searchText.isEmpty else {
            return employeeViewModel.employees
        }

        let query = searchText.lowercased()

        return employeeViewModel.employees.filter { employee in

            let fullName = (employee.name ?? "").lowercased()

            return fullName.contains(query)
                || employee.position?.lowercased().contains(query) == true
                || employee.department?.lowercased().contains(query) == true
        }
    }

    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                                    
                        Text("Employees")
                            .font(.largeTitle.bold())
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            
                            TextField("Search employees", text: $searchText)
                                .textFieldStyle(.plain)
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                    .background(Color(.systemBackground))
            }
            
            ZStack(alignment: .bottomTrailing) {
                
                Group {

                    if employeeViewModel.employees.isEmpty {

                        ContentUnavailableView(
                            "No Employees",
                            systemImage: "person.3",
                            description: Text(
                                "Tap + to add your first employee."
                            )
                        )

                    } else if filteredEmployees.isEmpty {

                        ContentUnavailableView(
                            "No Results",
                            systemImage: "magnifyingglass",
                            description: Text(
                                "No employees match \"\(searchText)\"."
                            )
                        )

                    } else {

                        ScrollView {

                            LazyVStack(spacing: 14) {
                                ForEach(filteredEmployees, id: \.objectID) { employee in
                                    EmployeeCard(
                                        employee: employee,
                                        onDelete: {
                                            showingDeleteFor = employee
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                Button {

                    showAddEmployee = true

                } label: {

                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(
                            width: 60,
                            height: 60
                        )
                        .background(
                            Color("background")
                        )
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddEmployee) {

                NavigationStack {
                    AddEmployeeView()
                }
                .environmentObject(employeeViewModel)
            }
            .confirmationDialog(
                "Delete Employee?",
                isPresented: Binding(
                    get: { showingDeleteFor != nil },
                    set: { if !$0 { showingDeleteFor = nil } }
                ),
                titleVisibility: .visible
            ) {

                Button(
                    "Delete",
                    role: .destructive
                ) {
                    if let employee = showingDeleteFor {
                        employeeViewModel.deleteEmployee(employee)
                    }
                    showingDeleteFor = nil
                }

                Button("Cancel", role: .cancel) {
                    showingDeleteFor = nil
                }
            }
        }
        .onAppear {
            employeeViewModel.fetchEmployees()
        }
    }
}

#Preview {
    NavigationStack {
        EmployeesView()
            .environmentObject(EmployeeViewModel())
    }
}
