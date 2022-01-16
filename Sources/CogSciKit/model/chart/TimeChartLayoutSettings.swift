//
// CogSciKit
//

import CoreGraphics

public struct TimeChartLayoutSettings {
    public let xAxis: LinearAxis<CGFloat>
    public let yAxis: LinearAxis<CGFloat>
    public let haloRadius: CGFloat
    public let lineWidth: CGFloat

    public init(
        xAxis: LinearAxis<CGFloat>,
        yAxis: LinearAxis<CGFloat>,
        haloRadius: CGFloat,
        lineWidth: CGFloat
    ) {
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.haloRadius = haloRadius
        self.lineWidth = lineWidth
    }
}
