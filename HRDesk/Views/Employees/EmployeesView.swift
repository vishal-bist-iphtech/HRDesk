//
//  EmployeesView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

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

            let fullName = "\(employee.firstName ?? "") \(employee.lastName ?? "")"
                .lowercased()

            return fullName.contains(query)
                || employee.position?.lowercased().contains(query) == true
                || employee.department?.lowercased().contains(query) == true
        }
    }

    var body: some View {
        NavigationStack {
            
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
            .navigationTitle("Employees")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer,
                prompt: "Search employees"
            )
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
