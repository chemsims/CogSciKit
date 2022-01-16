//
//  CogSciKit
//

import Foundation

extension Comparable {
    public func within(min: Self, max: Self) -> Self {
        precondition(max >= min, "Cannot check bounds when max is smaller than min")
        return Swift.min(max, Swift.max(min, self))
    }
}

extension BinaryFloatingPoint {
    public func str(decimals: Int) -> String {
        String(format: "%.\(decimals)f", Double(self))
    }

    /// Returns the value as a percentage where 1 corresponds to 100%
    public var percentage: String {
        "\((self * 100).str(decimals: 0))%"
    }

    public func roundedInt() -> Int {
        Int(rounded())
    }
}
