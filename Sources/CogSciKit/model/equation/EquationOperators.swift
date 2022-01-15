//
//  File.swift
//  

import CoreGraphics

public func * (lhs: Equation, rhs: Equation) -> Equation {
    OperatorEquation(lhs: lhs, rhs: rhs, op: *)
}

public func * (lhs: CGFloat, rhs: Equation) -> Equation {
    ConstantEquation(value: lhs) * rhs
}

public func / (lhs: Equation, rhs: Equation) -> Equation {
    OperatorEquation(lhs: lhs, rhs: rhs) { (l, r) in
        r == 0 ? 0 : l / r
    }
}

public func / (lhs: CGFloat, rhs: Equation) -> Equation {
    ConstantEquation(value: lhs) / rhs
}

public func / (lhs: Equation, rhs: CGFloat) -> Equation {
    lhs / ConstantEquation(value: rhs)
}

public func + (lhs: Equation, rhs: Equation) -> Equation {
    OperatorEquation(lhs: lhs, rhs: rhs, op: +)
}

public func + (lhs: CGFloat, rhs: Equation) -> Equation {
    ConstantEquation(value: lhs) + rhs
}

public func - (lhs: Equation, rhs: Equation) -> Equation {
    OperatorEquation(lhs: lhs, rhs: rhs, op: -)
}

public func - (lhs: Equation, rhs: CGFloat) -> Equation {
    lhs - ConstantEquation(value: rhs)
}

public func - (lhs: CGFloat, rhs: Equation) -> Equation {
    ConstantEquation(value: lhs) - rhs
}
