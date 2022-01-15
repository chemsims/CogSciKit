//
// CogSciKit
//

import CoreGraphics

public struct BoundEquation: Equation {
    let underlying: Equation
    private let constrainer: ValueConstrainer

    public init(
        underlying: Equation,
        lowerBound: CGFloat?,
        upperBound: CGFloat?
    ) {
        self.underlying = underlying
        self.constrainer = ValueConstrainer(lowerBound: lowerBound, upperBound: upperBound)
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        let value = underlying.getValue(at: input)
        return constrainer.constrain(value)
    }
}

/// Constraints the input to be with an optional upper and lower bound
public struct BoundInputEquation: Equation {
    
    let underlying: Equation
    private let constrainer: ValueConstrainer


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
        self.constrainer = ValueConstrainer(lowerBound: lowerBound, upperBound: upperBound)
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        let constrainedInput = constrainer.constrain(input)
        return underlying.getValue(at: constrainedInput)
    }
}

private struct ValueConstrainer {
    init(
        lowerBound: CGFloat?,
        upperBound: CGFloat?
    ) {
        precondition(
            lowerBound.flatMap { lb in upperBound.map { ub in ub >= lb }} ?? true,
            "Cannot create bounded equation when upper bound is smaller than lower bound"
        )
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    let lowerBound: CGFloat?
    let upperBound: CGFloat?
    
    func constrain(_ value: CGFloat) -> CGFloat {
        let withLowerBound = lowerBound.map { max($0, value) } ?? value
        return upperBound.map { min($0, withLowerBound) } ?? withLowerBound
    }
}
