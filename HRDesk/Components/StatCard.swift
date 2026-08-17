//
//  StatCard.swift
//  HRDesk
//
//  Created by iPHTech 34 on 10/08/26.
//

import SwiftUI


struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 40, height: 40)
                    .background(tint.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black.opacity(0.7))
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.gray.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    
    StatCard(icon:"person.2.fill", title:"Applied", value:"48",tint: .orange)
    
}
