//
//  InteractiveDonutChart.swift
//  HRDesk
//
//  Created by iPHTech 34 on 20/08/26.
//

import SwiftUI
import Charts

struct InteractiveDonutChart: View {

    let data: [DonutSlice]

    let centerTitle: String
    let centerSubtitle: String

    var centerValue: String? = nil

    var innerRadiusRatio: Double = 0.62

    var showsCenterLabel: Bool = true

    @State private var selectedID: String?

    private var total: Int {

        data.reduce(0) {
            $0 + $1.count
        }
    }

    private var selected: DonutSlice? {

        guard let selectedID else {
            return nil
        }

        return data.first {
            $0.id == selectedID
        }
    }

    var body: some View {

        Chart(data) { slice in

            SectorMark(
                angle: .value(
                    "Count",
                    slice.count
                ),
                innerRadius: .ratio(
                    innerRadiusRatio
                ),
                angularInset: 0.5
            )
            .cornerRadius(5)
            .foregroundStyle(
                slice.color
            )
            .opacity(
                selected == nil ||
                selected?.id == slice.id
                ? 1
                : 0.35
            )
        }
        .chartBackground { proxy in

            if showsCenterLabel,
               total > 0 {

                GeometryReader { geo in

                    if let plotFrame =
                        proxy.plotFrame {

                        let frame =
                            geo[plotFrame]

                        VStack(spacing: 2) {

                            Text(
                                selected?.label ??
                                centerTitle
                            )
                            .font(
                                .subheadline.weight(
                                    .semibold
                                )
                            )
                            .foregroundStyle(
                                .secondary
                            )
                            .lineLimit(1)

                            Text(
                                selected.map {
                                    "\($0.count)"
                                }
                                ?? (
                                    centerValue
                                    ?? "\(total)"
                                )
                            )
                            .font(
                                .title2.bold()
                            )
                            .foregroundStyle(
                                Color("textPrimary")
                            )

                            if selected != nil {

                                Text(
                                    "\(Int(Double(selected!.count) / Double(total) * 100))%"
                                )
                                .font(
                                    .caption.weight(
                                        .semibold
                                    )
                                )
                                .foregroundStyle(
                                    Color("background")
                                )
                            }
                        }
                        .position(
                            x: frame.midX,
                            y: frame.midY
                        )
                    }
                }
            }
        }
        .chartOverlay { proxy in

            GeometryReader { geo in

                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in

                                selectSlice(
                                    at: value.location,
                                    in: geo,
                                    proxy: proxy
                                )
                            }
                    )
            }
        }
    }

    private func selectSlice(
        at location: CGPoint,
        in geo: GeometryProxy,
        proxy: ChartProxy
    ) {

        guard total > 0,
              let plotFrame = proxy.plotFrame
        else {
            return
        }

        let frame = geo[plotFrame]

        let center = CGPoint(
            x: frame.midX,
            y: frame.midY
        )

        let dx =
            location.x - center.x

        let dy =
            location.y - center.y

        let radius =
            sqrt(
                dx * dx +
                dy * dy
            )

        let outerRadius =
            min(
                frame.width,
                frame.height
            ) / 2

        let innerRadius =
            outerRadius *
            innerRadiusRatio

        guard radius >= innerRadius,
              radius <= outerRadius
        else {

            selectedID = nil

            return
        }

        var angle =
            atan2(dy, dx)
            * 180
            / .pi
            + 90

        if angle < 0 {

            angle += 360

        } else if angle >= 360 {

            angle -= 360
        }

        var cumulative = 0.0

        for slice in data {

            cumulative +=
                Double(slice.count)
                / Double(total)
                * 360

            if angle < cumulative {

                selectedID = slice.id

                return
            }
        }

        selectedID = nil
    }
}