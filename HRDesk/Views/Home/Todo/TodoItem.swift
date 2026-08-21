//
//  TodoItem.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI

struct TodoItem: View {

    let todo: TodoEntity
    let onToggle: () -> Void

    enum Priority: String {
        case high = "High"
        case medium = "Medium"
        case low = "Low"

        var color: Color {

            switch self {

            case .high:
                return .red

            case .medium:
                return .orange

            case .low:
                return .green
            }
        }
    }

    private var priority: Priority {

        Priority(
            rawValue: todo.priority ?? "Medium"
        ) ?? .medium
    }

    var body: some View {

        Button {

            onToggle()

        } label: {

            HStack(spacing: 12) {

                Image(
                    systemName:
                        todo.isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.title3)
                .foregroundStyle(
                    todo.isCompleted
                    ? .green
                    : .secondary.opacity(0.4)
                )

                VStack(alignment: .leading, spacing: 4) {

                    Text(todo.title ?? "")
                        .font(
                            .subheadline.weight(.medium)
                        )
                        .foregroundStyle(
                            todo.isCompleted
                            ? .secondary
                            : Color("textPrimary")
                        )
                        .strikethrough(
                            todo.isCompleted
                        )

                    HStack(spacing: 8) {

                        Image(systemName: "clock")
                            .font(.caption2)

                        Text(
                            todo.dueDate?
                                .formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                ) ?? ""
                        )
                        .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Text(priority.rawValue)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(priority.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(priority.color.opacity(0.12))
                    .clipShape(Capsule())
            }
            .padding(12)
            .background(Color.gray.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
