//
// CogSciKit
//

import SwiftUI

public struct TimeChartDataLineView: View {

    let data: TimeChartDataLine
    let settings: TimeChartLayoutSettings
    let lineWidth: CGFloat

    let initialTime: CGFloat
    @Binding var currentTime: CGFloat
    let finalTime: CGFloat

    let filledBarColor: Color
    let canSetCurrentTime: Bool

    let highlightLhs: Bool
    let highlightRhs: Bool
    let clipData: Bool

    let offset: CGFloat
    let minDragTime: CGFloat?

    public init(
        data: TimeChartDataLine,
        settings: TimeChartLayoutSettings,
        lineWidth: CGFloat,
        initialTime: CGFloat,
        currentTime: Binding<CGFloat>,
        finalTime: CGFloat,
        filledBarColor: Color,
        canSetCurrentTime: Bool,
        highlightLhs: Bool,
        highlightRhs: Bool,
        clipData: Bool = false,
        offset: CGFloat = 0,
        minDragTime: CGFloat? = nil
    ) {
        self.data = data
        self.settings = settings
        self.lineWidth = lineWidth
        self.initialTime = initialTime
        self._currentTime = currentTime
        self.finalTime = finalTime
        self.filledBarColor = filledBarColor
        self.canSetCurrentTime = canSetCurrentTime
        self.highlightLhs = highlightLhs
        self.highlightRhs = highlightRhs
        self.clipData = clipData
        self.offset = offset
        self.minDragTime = minDragTime
    }

    public var body: some View {
        ZStack {
            if data.showFilledLine {
                dataLine(time: finalTime + offset, color: filledBarColor)
            }

            dataLine(time: currentTime, color: data.headColor)
            if highlightLhs {
                highlightLine(startTime: initialTime, endTime: (initialTime + finalTime) / 2)
            }
            if highlightRhs {
                highlightLine(startTime: (initialTime + finalTime) / 2, endTime: finalTime)
            }

            if data.haloColor != nil {
                head(
                    radius: settings.haloRadius,
                    color: data.haloColor!
                )
                .contentShape(Rectangle())
                .gesture(canSetCurrentTime ? dragGesture : nil)
            }
            head(
                radius: data.headRadius,
                color: data.headColor
            )
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0).onChanged { gesture in
            guard canSetCurrentTime else {
                return
            }
            let xLocation = gesture.location.x
            let shiftedAxis = settings.xAxis.shift(by: offset)
            let newTime = shiftedAxis.getValue(at: xLocation)

            let minTime = minDragTime ?? initialTime + offset
            let maxTime = finalTime + offset
            currentTime = max(minTime, min(maxTime, newTime))
        }
    }

    private func head(
        radius: CGFloat,
        color: Color
    ) -> some View {
        ChartIndicatorHead(
            radius: radius,
            equation: data.equation,
            xEquation: data.xEquation,
            yAxis: settings.yAxis,
            xAxis: settings.xAxis,
            x: currentTime,
            offset: offset
        )
        .fill()
        .foregroundColor(color)
    }

    private func dataLine(
        time: CGFloat,
        color: Color
    ) -> some View {
        line(
            startTime: initialTime,
            time: time,
            color: color,
            lineWidth: lineWidth
        )
    }

    private func highlightLine(
        startTime: CGFloat,
        endTime: CGFloat
    ) -> some View {
        line(
            startTime: startTime,
            time: endTime,
            color: data.headColor,
            lineWidth: 2.5 * lineWidth
        )
    }

    @ViewBuilder
    private func line(
        startTime: CGFloat,
        time: CGFloat,
        color: Color,
        lineWidth: CGFloat
    ) -> some View {
        let view = ChartLine(
            equation: data.equation,
            xEquation: data.xEquation,
            yAxis: settings.yAxis,
            xAxis: settings.xAxis,
            startX: startTime,
            endX: time,
            offset: offset,
            discontinuity: data.discontinuity
        )
        .stroke(lineWidth: lineWidth)
        .foregroundColor(color)

        if clipData {
            view.clipped()
        } else {
            view
        }
    }
}
