//
// CogSciKit
//

import CoreGraphics

public struct LinearEquation: Equation {
    public let m: CGFloat
    public let c: CGFloat

    public init(m: CGFloat, x1: CGFloat, y1: CGFloat) {
        self.m = m
        self.c = y1 - (m * x1)
    }

    /// Creates a new instance which passes through the points (`x1`, `y1`) and (`x2`, `y2`).
    ///
    /// - Note: When `x1 == x2`, the resulting equation will have a constant value of `y1`.
    public init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        let denom = x2 - x1
        let m = denom == 0 ? 0 : (y2 - y1) / denom
        self.init(m: m, x1: x1, y1: y1)
    }
    
    /// Returns a `LinearEquation` which varies with some fractional input - i.e., an input between 0 and 1.
    ///
    /// - Parameters:
    ///   - valueAtMin: The value returned for inputs of  0.
    ///   - valueAtMax: The value returned for inputs of 1.
    public static func fractioned(valueAtMin: CGFloat, valueAtMax: CGFloat) -> LinearEquation {
        LinearEquation(x1: 0, y1: valueAtMin, x2: 1, y2: valueAtMax)
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        (m * input) + c
    }

    public func getX(at y: CGFloat) -> CGFloat {
        m == 0 ? 0 : (y - c) / m
    }

    public func intersectionWith(other: LinearEquation) -> CGPoint? {
        let numer = other.c - c
        let denom = m - other.m
        if denom == 0 {
            return nil
        }

        let xIntersect = numer / denom
        let yIntersect = getValue(at: xIntersect)
        return CGPoint(x: xIntersect, y: yIntersect)
    }
}

/// A linear equation which enforces that the `y` value has a minimum value at a given `x` value.
///
/// If the provided linear equation would be lower than the `minIntersection` point, then a switching
/// equation is instead used with a linear line on the left of the intersection from `x1`, `y1` up to the intersection, and
/// another linear line on the right of the intersection to `x2`, `y2`.
public struct LinearEquationWithMinIntersection: Equation {
    public init(
        x1: CGFloat,
        y1: CGFloat,
        x2: CGFloat,
        y2: CGFloat,
        minIntersection: CGPoint
    ) {
        let idealEquation = LinearEquation(x1: x1, y1: y1, x2: x2, y2: y2)
        let yValueAtIntersection = idealEquation.getValue(at: minIntersection.x)

        if yValueAtIntersection > minIntersection.y {
            self.underlying = idealEquation
        } else {
            self.underlying = SwitchingEquation(
                thresholdX: minIntersection.x,
                underlyingLeft: LinearEquation(x1: x1, y1: y1, x2: minIntersection.x, y2: minIntersection.y),
                underlyingRight: LinearEquation(x1: minIntersection.x, y1: minIntersection.y, x2: x2, y2: y2)
            )
        }
    }

    let underlying: Equation

    public func getValue(at x: CGFloat) -> CGFloat {
        underlying.getValue(at: x)
    }
}
