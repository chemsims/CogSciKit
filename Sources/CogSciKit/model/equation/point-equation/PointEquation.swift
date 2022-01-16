//
// CogSciKit
//

import CoreGraphics

public protocol PointEquation {
    func getPoint(at progress: CGFloat) -> CGPoint
}

public struct ConstantPointEquation: PointEquation {
    public init(_ value: CGPoint) {
        self.value = value
    }

    let value: CGPoint

    public func getPoint(at progress: CGFloat) -> CGPoint {
        value
    }
}

public struct SwitchingPointEquation: PointEquation {
    
    public init(left: PointEquation, right: PointEquation, thresholdProgress: CGFloat) {
        self.left = left
        self.right = right
        self.thresholdProgress = thresholdProgress
    }
    
    let left: PointEquation
    let right: PointEquation
    let thresholdProgress: CGFloat
    
    public func getPoint(at progress: CGFloat) -> CGPoint {
        if progress < thresholdProgress {
            return left.getPoint(at: progress)
        }
        return right.getPoint(at: progress)
    }
}

public struct LinearPointEquation: PointEquation {

    public init(initial: CGPoint, final: CGPoint, initialProgress: CGFloat = 0, finalProgress: CGFloat = 1) {
        self.underlying = WrappedPointEquation(
            xEquation: LinearEquation(
                x1: initialProgress,
                y1: initial.x,
                x2: finalProgress,
                y2: final.x
            ),
            yEquation: LinearEquation(
                x1: initialProgress,
                y1: initial.y,
                x2: finalProgress,
                y2: final.y
            )
        )
    }

    private let underlying: WrappedPointEquation

    public func getPoint(at progress: CGFloat) -> CGPoint {
        underlying.getPoint(at: progress)
    }
}

public struct WrappedPointEquation: PointEquation {
    
    public init(xEquation: Equation, yEquation: Equation) {
        self.xEquation = xEquation
        self.yEquation = yEquation
    }
    
    let xEquation: Equation
    let yEquation: Equation

    public func getPoint(at progress: CGFloat) -> CGPoint {
        CGPoint(
            x: xEquation.getValue(at: progress),
            y: yEquation.getValue(at: progress)
        )
    }
}
