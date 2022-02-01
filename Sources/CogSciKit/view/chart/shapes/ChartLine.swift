//
// CogSciKit
//

import SwiftUI

public struct ChartLine: Shape {

    let equation: Equation
    let xEquation: Equation?

    let yAxis: LinearAxis<CGFloat>
    let xAxis: LinearAxis<CGFloat>

    let startX: CGFloat
    var endX: CGFloat

    var offset: CGFloat

    let discontinuity: CGFloat?

    public init(
        equation: Equation,
        xEquation: Equation? = nil,
        yAxis: LinearAxis<CGFloat>,
        xAxis: LinearAxis<CGFloat>,
        startX: CGFloat,
        endX: CGFloat,
        offset: CGFloat = 0,
        discontinuity: CGFloat? = nil
    ) {
        self.equation = equation
        self.xEquation = xEquation
        self.yAxis = yAxis
        self.xAxis = xAxis
        self.startX = startX
        self.endX = endX
        self.offset = offset
        self.discontinuity = discontinuity
    }

    private let maxWidthSteps = 100

    private var shiftedXAxis: LinearAxis<CGFloat> {
        xAxis.shift(by: offset)
    }

    // TODO - make this safer by breaking early when the x range is 0
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let dxPos = rect.width / CGFloat(maxWidthSteps)
        let dx1 = shiftedXAxis.getValue(at: dxPos) - shiftedXAxis.getValue(at: 0)
        let dx = startX < endX ? dx1 : -dx1

        var didStart = false

        func addLine(x: CGFloat, y: CGFloat) {
            let xValue = xEquation?.getValue(at: x) ?? x
            let xPosition = shiftedXAxis.getPosition(at: xValue)
            let yPosition = yAxis.getPosition(at: y)
            if didStart {
                path.addLine(to: CGPoint(x: xPosition, y: yPosition))
            } else {
                path.move(to: CGPoint(x: xPosition, y: yPosition))
                didStart = true
            }
        }
        
        // We draw a small part of the line just before and after the discontinuity (if there is one)
        let discontinuityDelta = dx / 100

        if let dc = discontinuity {
            for x in strideLhs(dx: dx, discontinuity: dc) {
                let y = equation.getValue(at: x)
                addLine(x: x, y: y)
            }
            let preDc = dc - discontinuityDelta
            addLine(x: preDc, y: equation.getValue(at: preDc))
            addLine(x: dc, y: equation.getValue(at: dc))
        }

        for x in strideRhs(dx: dx, discontinuityDelta: discontinuityDelta) {
            let y = equation.getValue(at: x)
            addLine(x: x, y: y)
        }
        addLine(x: endX, y: equation.getValue(at: endX))

        return path
    }

    private func strideLhs(dx: CGFloat, discontinuity: CGFloat) -> StrideTo<CGFloat> {
        stride(from: startX + offset, to: discontinuity, by: dx)
    }

    private func strideRhs(dx: CGFloat, discontinuityDelta: CGFloat) -> StrideTo<CGFloat> {
        if let dc = discontinuity {
            let postDc = dc + discontinuityDelta
            return stride(from: postDc, to: endX, by: dx)
        } else {
            return stride(from: startX + offset, to: endX, by: dx)
        }
    }

    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, endX)  }
        set {
            offset = newValue.first
            endX = newValue.second
        }
    }
}

struct ChartLine_Previews: PreviewProvider {

    static var previews: some View {
        ViewStateWrapper()
    }

    struct ViewStateWrapper: View {
        @State var t2: CGFloat = 0
        
        let discontinuity: CGFloat = 5

        var body: some View {
            VStack {
                ZStack {
                    ChartLine(
                        equation: discontinuousEquation(),
                        yAxis: yAxis,
                        xAxis: xAxis,
                        startX: 0,
                        endX: t2,
                        discontinuity: discontinuity
                    ).stroke(lineWidth: 2)

                    ChartIndicatorHead(
                        radius: 10,
                        equation: discontinuousEquation(),
                        yAxis: yAxis,
                        xAxis: xAxis,
                        x: t2,
                        offset: 0
                    )
                }
                .frame(width: 250, height: 250)
                .border(Color.red)

                Button(action: {
                    withAnimation(.linear(duration: 1)) {
                        if self.t2 == 50 {
                            self.t2 = 0
                        } else {
                            self.t2 = 50
                        }
                    }
                }) {
                    Text("Click me")
                }
            }
        }

        private var yAxis: LinearAxis<CGFloat> {
            LinearAxis(
                minValuePosition: 240,
                maxValuePosition: 10,
                minValue: 0,
                maxValue: 10)
        }

        private var xAxis: LinearAxis<CGFloat> {
            LinearAxis(
                minValuePosition: 10,
                maxValuePosition: 250 - 10,
                minValue: 0,
                maxValue: 10
            )
        }
        
        private func discontinuousEquation() -> Equation {
            SwitchingEquation(
                thresholdX: discontinuity,
                underlyingLeft: LinearEquation(m: 1, x1: 0, y1: 0),
                underlyingRight: ConstantEquation(value: 2)
            )
        }
    }
}

