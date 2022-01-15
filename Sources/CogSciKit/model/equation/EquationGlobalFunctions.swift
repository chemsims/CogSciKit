//
// CogSciKit
//

import CoreGraphics

public func pow(_ base: Equation, _ exponent: CGFloat) -> Equation {
    pow(base, ConstantEquation(value: exponent))
}

public func pow(_ base: CGFloat, _ exponent: Equation) -> Equation {
    pow(ConstantEquation(value: base), exponent)
}

public func pow(_ base: Equation, _ exponent: Equation) -> Equation {
    OperatorEquation(lhs: base, rhs: exponent) { pow($0, $1) }
}
