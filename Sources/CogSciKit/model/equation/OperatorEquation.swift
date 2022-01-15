//
// CogSciKit
//  

import CoreGraphics

/// An equation which evaluates two equations for the same input, and returns the result of
/// the provided operator which combines them.
public struct OperatorEquation: Equation {
    public let lhs: Equation
    public let rhs: Equation
    public let op: (CGFloat, CGFloat) -> CGFloat

    public init(lhs: Equation, rhs: Equation, op: @escaping (CGFloat, CGFloat) -> CGFloat) {
        self.lhs = lhs
        self.rhs = rhs
        self.op = op
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        op(lhs.getValue(at: input), rhs.getValue(at: input))
    }
}
