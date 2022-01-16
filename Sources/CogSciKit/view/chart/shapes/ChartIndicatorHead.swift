//
// CogSciKit
//

import SwiftUI

public struct ChartIndicatorHead: Shape {

    let radius: CGFloat
    let equation: Equation
    let xEquation: Equation?

    let yAxis: LinearAxis<CGFloat>
    let xAxis: LinearAxis<CGFloat>

    var x: CGFloat
    var offset: CGFloat

    public init(
        radius: CGFloat,
        equation: Equation,
        xEquation: Equation? = nil,
        yAxis: LinearAxis<CGFloat>,
        xAxis: LinearAxis<CGFloat>,
        x: CGFloat,
        offset: CGFloat
    ) {
        self.radius = radius
        self.equation = equation
        self.xEquation = xEquation
        self.yAxis = yAxis
        self.xAxis = xAxis
        self.x = x
        self.offset = offset
    }


    private var shiftedXAxis: LinearAxis<CGFloat> {
        xAxis.shift(by: offset)
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let y = equation.getValue(at: x)

        let xValue = xEquation?.getValue(at: x) ?? x
        let xPosition = shiftedXAxis.getPosition(at: xValue)
        let yPosition = yAxis.getPosition(at: y)

        let containerRect = CGRect(
            origin: CGPoint(x: xPosition - radius, y: yPosition - radius),
            size: CGSize(width: radius * 2, height: radius * 2)
        )
        path.addEllipse(in: containerRect)

        return path
    }

    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, x) }
        set {
            offset = newValue.first
            x = newValue.second
        }
    }

}
