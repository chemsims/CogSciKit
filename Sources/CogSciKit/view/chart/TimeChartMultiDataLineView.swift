//
// CogSciKit
//

import SwiftUI

public struct TimeChartMultiDataLineView: View {

    let data: [TimeChartDataLine]
    let settings: TimeChartLayoutSettings

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
    let activeIndex: Int?

    public init(
        data: [TimeChartDataLine],
        settings: TimeChartLayoutSettings,
        initialTime: CGFloat,
        currentTime: Binding<CGFloat>,
        finalTime: CGFloat,
        filledBarColor: Color,
        canSetCurrentTime: Bool,
        highlightLhs: Bool = false,
        highlightRhs: Bool = false,
        clipData: Bool = false,
        offset: CGFloat = 0,
        minDragTime: CGFloat? = nil,
        activeIndex: Int? = nil
    ) {
        self.data = data
        self.settings = settings
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
        self.activeIndex = activeIndex
    }

    public var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { i in
                TimeChartDataLineView(
                    data: data[i],
                    settings: settings,
                    lineWidth: activeIndex == i ? 2 * settings.lineWidth : settings.lineWidth,
                    initialTime: initialTime,
                    currentTime: $currentTime,
                    finalTime: finalTime,
                    filledBarColor: filledBarColor,
                    canSetCurrentTime: canSetCurrentTime,
                    highlightLhs: highlightLhs,
                    highlightRhs: highlightRhs,
                    clipData: clipData,
                    offset: offset,
                    minDragTime: minDragTime
                )
                .opacity(activeIndex.forAll({$0 == i }) ? 1 : 0.3)
                .zIndex(activeIndex == i ? 1 : 0)
            }
        }
    }
}


struct TimeChartDataLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeChartMultiDataLineView(
            data: allData,
            settings: settings,
            initialTime: 0,
            currentTime: .constant(10),
            finalTime: 10,
            filledBarColor: .black,
            canSetCurrentTime: false,
            highlightLhs: false,
            highlightRhs: false,
            offset: 5
        )
        .frame(width: 300, height: 300)
        .border(Color.black)
    }

    private static var settings: TimeChartLayoutSettings {
        TimeChartLayoutSettings(
            xAxis: LinearAxis<CGFloat>(
                minValuePosition: 0,
                maxValuePosition: 300,
                minValue: 0,
                maxValue: 10
            ),
            yAxis: LinearAxis<CGFloat>(
                minValuePosition: 300,
                maxValuePosition: 0,
                minValue: 0,
                maxValue: 10
            ),
            haloRadius: 18,
            lineWidth: 2
        )
    }

    private static var allData: [TimeChartDataLine] {
        [
            data(
                makeEquation(
                    parabola: CGPoint(x: 5, y: 0),
                    through: CGPoint(x: 0, y: 5)
                ),
                .red
            ),
            data(
                makeEquation(
                    parabola: CGPoint(x: 4, y: 6),
                    through: CGPoint(x: 0, y: 2)
                ),
                .orange
            ),
            data(
                makeEquation(
                    parabola: CGPoint(x: 4, y: 8),
                    through: CGPoint(x: 0, y: 4)
                ),
                .purple
            ),
            data(
                LinearEquation(m: 0.5, x1: 0, y1: 0),
                .black
            )
        ]
    }

    private static func makeEquation(
        parabola: CGPoint,
        through: CGPoint
    ) -> Equation {
        SwitchingEquation(
            thresholdX: parabola.x,
            underlyingLeft: QuadraticEquation(parabola: parabola, through: through),
            underlyingRight: ConstantEquation(value: parabola.y)
        )
    }

    private static func data(_ equation: Equation, _ color: Color) -> TimeChartDataLine {
        TimeChartDataLine(
            equation: equation,
            headColor: color,
            haloColor: color.opacity(0.3),
            headRadius: 6
        )
    }
}
