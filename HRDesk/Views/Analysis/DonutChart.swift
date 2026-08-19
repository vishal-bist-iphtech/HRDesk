//
//  DonutChart.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI
import Charts

struct DonutChart: View {

    let data: [DonutSlice]

    var innerRadiusRatio: Double = 0.62

    var body: some View {

        Chart(data) { slice in

            SectorMark(
                angle: .value("Count", slice.count),
                innerRadius: .ratio(innerRadiusRatio),
                angularInset: 0.5
            )
            .cornerRadius(5)
            .foregroundStyle(slice.color)
        }
    }
}