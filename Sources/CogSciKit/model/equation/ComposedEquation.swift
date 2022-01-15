//
// CogSciKit
//  

import CoreGraphics

/// An equation which passes the result of the `inner` equation as input to the `outer`
/// equation.
///
/// This equation can be considered as `y(x) = g(f(x))`, where `f` is the inner equation
/// and `g` is the outer equation.
public struct ComposedEquation: Equation {

    public init(outer: Equation, inner: Equation) {
        self.outer = outer
        self.inner = inner
    }

    let outer: Equation
    let inner: Equation

    public func getValue(at input: CGFloat) -> CGFloat {
        outer.getValue(at: inner.getValue(at: input))
    }
}
