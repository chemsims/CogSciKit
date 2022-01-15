//
// CogSciKit
//

import CoreGraphics

/// An equation represents some pure transformation from an input value to an output value.
///
/// - Note: Most equations return 0 rather than an undefined number (e.g. division by 0).
public protocol Equation {
    func getValue(at input: CGFloat) -> CGFloat
}

extension Equation {
    public func within(min: CGFloat, max: CGFloat) -> Equation {
        BoundEquation(underlying: self, lowerBound: min, upperBound: max)
    }
    
    /// Returns a new equation which always enforces that it's input is within `min` and `max` inclusive.
    public func inputWithin(min: CGFloat, max: CGFloat) -> Equation {
        BoundInputEquation(underlying: self, lowerBound: min, upperBound: max)
    }

    public func upTo(_ max: CGFloat) -> Equation {
        BoundEquation(underlying: self, lowerBound: nil, upperBound: max)
    }

    public func atLeast(_ min: CGFloat) -> Equation {
        BoundEquation(underlying: self, lowerBound: min, upperBound: nil)
    }

    public func map(_ transform: @escaping (CGFloat) -> CGFloat) -> Equation {
        ComposedEquation(
            outer: AnonymousEquation(transform: transform),
            inner: self
        )
    }
}
