//
//  ConversionRow.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI

struct ConversionRow: View {
    
    let title: String
    let percentage: Int
    let tint: Color

    var body: some View {

        HStack(spacing: 12) {

            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color("textPrimary"))

            Spacer()

            Text("\(percentage)%")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(Color.gray.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
