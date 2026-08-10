//
//  JobCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//
import SwiftUI

struct JobCard: View {
    
    let job: JobEntity
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            
            HStack(
                alignment: .top
            ) {
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    
                    Text(
                        job.title ?? "Untitled"
                    )
                    .font(.headline)
                    .foregroundStyle(
                        Color("textPrimary")
                    )
                }
                
                Spacer()
                
                Text(
                    job.employmentType ?? "Full Time"
                )
                .font(.caption2)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Color("textSecondary")
                        .opacity(0.12)
                )
                .foregroundStyle(
                    Color("textSecondary")
                )
                .clipShape(
                    Capsule()
                )
            }
            
            HStack(spacing: 12) {
                
                Label(
                    job.location ?? "",
                    systemImage: "mappin.and.ellipse"
                )
                
                Label(
                    job.experience ?? "",
                    systemImage: "briefcase"
                )
                
                Label(
                    job.salaryRange ?? "Not disclosed",
                    systemImage: "indianrupeesign.circle"
                )
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            if let jd = job.jd,
               !jd.isEmpty {
                
                Text(jd)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            Color.gray.opacity(0.06)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}
