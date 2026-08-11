//
//  EmployeesView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct EmployeesView: View {

    private let employees = [
        ("James Wilson", "Engineering Manager"),
        ("Nina Rodriguez", "People Operations Lead"),
        ("Akshay Verma", "Senior Data Analyst")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(employees, id: \.0) { employee in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.green.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(employee.0.prefix(1))
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                )

                            VStack(alignment: .leading, spacing: 3) {
                                Text(employee.0)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Color("textPrimary"))
                                Text(employee.1)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(12)
                        .background(Color.gray.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .background(Color("background").ignoresSafeArea())
            .navigationTitle("Employees")
        }
    }
}

#Preview {
    EmployeesView()
}
