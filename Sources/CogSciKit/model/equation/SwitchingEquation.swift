//
// CogSciKit
//

import CoreGraphics

/// An equation which switches between two underlying equations at some cutoff
public struct SwitchingEquation: Equation {

    public let thresholdX: CGFloat
    public let underlyingLeft: Equation
    public let underlyingRight: Equation

    /// Creates a new equation which switches between two underlying equations at the given X threshold
    ///
    /// - Parameters:
    ///     - thresholdX: The X value at which to switch to the right equation
    ///     - underlyingLeft: Equation to use for values less than `thresholdX`
    ///     - underlyingRight: Equation to use for values greater than or equal to `thresholdX`
    ///     -
    public init(
        thresholdX: CGFloat,
        underlyingLeft: Equation,
        underlyingRight: Equation
    ) {
        self.thresholdX = thresholdX
        self.underlyingLeft = underlyingLeft
        self.underlyingRight = underlyingRight
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        if input < thresholdX {
            return underlyingLeft.getValue(at: input)
        }
        return underlyingRight.getValue(at: input)
    }

    /// Returns a switching equation with two linear lines that switch at the
    /// provided `mid` point.
    public static func linear(
        initial: CGPoint,
        mid: CGPoint,
        final: CGPoint
    ) -> SwitchingEquation {
        SwitchingEquation(
            thresholdX: mid.x,
            underlyingLeft: LinearEquation(
                x1: initial.x,
                y1: initial.y,
                x2: mid.x,
                y2: mid.y
            ),
            underlyingRight: LinearEquation(
                x1: mid.x,
                y1: mid.y,
                x2: final.x,
                y2: final.y
            )
        )
    }
}
