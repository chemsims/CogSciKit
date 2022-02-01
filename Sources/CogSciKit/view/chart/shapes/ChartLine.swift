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

    fileprivate let maxWidthSteps = 100

    fileprivate var shiftedXAxis: LinearAxis<CGFloat> {
        xAxis.shift(by: offset)
    }
    
    public func path(in rect: CGRect) -> Path {
        let helper = ChartLineHelper(underlying: self, rect: rect, path: Path())
        helper.drawPath()
        return helper.path
    }
    
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset, endX)  }
        set {
            offset = newValue.first
            endX = newValue.second
        }
    }
}


private class ChartLineHelper {
    
    init(underlying: ChartLine, rect: CGRect, path: Path) {
        self.underlying = underlying
        self.rect = rect
        self.path = path
    }
    
    // No need to be weak, since lifecycle of the helper is only in scope in the drawing
    // method of underlying ChartLine
    let underlying: ChartLine
    
    let rect: CGRect
    var path: Path
    
    func drawPath() {
        guard !didEnd else {
            return
        }
        if let discontinuity = underlying.discontinuity, discontinuity <= underlying.endX {
            addLinesWithDiscontinuity(discontinuity: discontinuity)
        } else {
            addAllLines()
        }
        didEnd = true
    }
    
    private func addLinesWithDiscontinuity(discontinuity: CGFloat) {
        let discontinuityDelta = dx / 100
        let preDc = discontinuity - discontinuityDelta
        addLinesUpToAndIncluding(from: underlying.startX + underlying.offset, to: preDc)
        addLine(to: discontinuity)
        
        let postDc = discontinuity + discontinuityDelta
        if postDc < underlying.endX {
            addLinesUpToAndIncluding(from: postDc, to: underlying.endX)
        }
    }
    
    private func addAllLines() {
        addLinesUpToAndIncluding(from: underlying.startX + underlying.offset, to: underlying.endX)
    }
    
    private func addLinesUpToAndIncluding(from: CGFloat, to upperLimit: CGFloat) {
        for x in stride(from: from, to: upperLimit, by: dx) {
            addLine(to: x)
        }
        addLine(to: upperLimit)
    }
    
    private func addLine(to x: CGFloat) {
        addLine(x: x, y: underlying.equation.getValue(at: x))
    }
        
    private func addLine(x: CGFloat, y: CGFloat) {
        let xValue = underlying.xEquation?.getValue(at: x) ?? x
        let xPosition = underlying.shiftedXAxis.getPosition(at: xValue)
        let yPosition = underlying.yAxis.getPosition(at: y)
        if didStart {
            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        } else {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
            didStart = true
        }
    }
    
    private var didStart = false
    private var didEnd = false
    
    private var dx: CGFloat {
        let dxPos = rect.width / CGFloat(underlying.maxWidthSteps)
        let dx1 = underlying.shiftedXAxis.getValue(at: dxPos) - underlying.shiftedXAxis.getValue(at: 0)
        return underlying.startX < underlying.endX ? dx1 : -dx1
    }
}

struct ChartLine_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            ViewStateWrapper(t2: 0)
            ViewStateWrapper(t2: 5)
        }
    }

    struct ViewStateWrapper: View {
        
        let t2: CGFloat
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

//                Button(action: {
//                    withAnimation(.linear(duration: 1)) {
//                        if self.t2 == 50 {
//                            self.t2 = 0
//                        } else {
//                            self.t2 = 50
//                        }
//                    }
//                }) {
//                    Text("Click me")
//                }
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

