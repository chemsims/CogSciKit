//
// CogSciKit
//

import CoreGraphics

/// Returns the natural logarithm of `underlying`
/// Returns 0 for inputs of 0
public struct LogEquation: Equation {
    let underlying: Equation

    public init(underlying: Equation) {
        self.underlying = underlying
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        let value = underlying.getValue(at: input)
        return value == 0 ? 0 : log(value)
    }
}

/// Returns log base 10 of either the input `x`, or wraps an `underlying` equation
/// Returns 0 for inputs of 0
public struct Log10Equation: Equation {
    let underlying: Equation

    public init() {
        self.init(underlying: IdentityEquation())
    }

    public init(underlying: Equation) {
        self.underlying = underlying
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        let value = underlying.getValue(at: input)
        return value <= 0 ? 0 : log10(value)
    }
}
