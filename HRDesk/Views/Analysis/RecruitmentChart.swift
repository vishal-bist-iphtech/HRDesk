//
//  RecruitmentChart.swift
//  HRDesk
//
//  Created by iPHTech 34 on 19/08/26.
//

import SwiftUI

struct RecruitmentChart: View {

    let stages: [AnalyticsViewModel.FunnelStageData]

    private var maxCount: Int {

        stages.map(\.count).max() ?? 1
    }

    var body: some View {

        VStack(spacing: 12) {

            ForEach(stages,id: \.id) { stage in

                HStack(spacing: 12) {

                    Text(stage.title)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color("textPrimary"))
                        .frame(width: 80, alignment: .leading)

                    GeometryReader { geometry in

                        ZStack(alignment: .leading) {

                            Capsule()
                                .fill(Color.gray.opacity(0.10))

                            Capsule()
                                .fill(stage.color)
                                .frame(width:geometry.size.width * CGFloat(stage.count) / CGFloat(maxCount))
                        }
                    }
                    .frame(height: 18)

                    Text("\(stage.count)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(stage.color)
                        .frame(width: 35,alignment: .trailing)
                }
                .frame(height: 22)
            }
        }
    }
}
