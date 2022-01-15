//
// CogSciKit
//

import CoreGraphics

public struct BoundEquation: Equation {
    let underlying: Equation
    let lowerBound: CGFloat?
    let upperBound: CGFloat?

    public init(
        underlying: Equation,
        lowerBound: CGFloat?,
        upperBound: CGFloat?
    ) {
        precondition(
            lowerBound.flatMap { lb in upperBound.map { ub in ub >= lb }} ?? true,
            "Cannot create bounded equation when upper bound is smaller than lower bound"
        )
        self.underlying = underlying
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        let value = underlying.getValue(at: input)
        let withLowerBound = lowerBound.map { max($0, value) } ?? value
        return upperBound.map { min($0, withLowerBound) } ?? withLowerBound
    }
}
