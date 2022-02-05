//
//  CogSciKit
//

import Foundation

extension String {
    public static func fromFloat(_ value: Double, decimals: Int) -> String {
        let result = String(format: "%.\(decimals)f", value)
        return removedLeadingNegativeForZero(result: result)
    }
    
    private static func removedLeadingNegativeForZero(result: String) -> String {
        guard let first = result.first, first == "-" else {
            return result
        }
        
        let parts = result.dropFirst().split(separator: ".")
        let partsAreAllZero = parts.allSatisfy { part in
            part.allSatisfy { $0 == "0" }
        }
        
        if partsAreAllZero, let firstPart = parts.first {
            let remainingParts = parts.dropFirst()
            return remainingParts.reduce(String(firstPart)) {
                $0 + "." + $1
            }
        }
        
        return result
    }
}

extension Comparable {
    public func within(min: Self, max: Self) -> Self {
        precondition(max >= min, "Cannot check bounds when max is smaller than min")
        return Swift.min(max, Swift.max(min, self))
    }
}

extension BinaryFloatingPoint {
    public func str(decimals: Int) -> String {
        String.fromFloat(Double(self), decimals: decimals)
    }

    /// Returns the value as a percentage where 1 corresponds to 100%
    public var percentage: String {
        "\((self * 100).str(decimals: 0))%"
    }

    public func roundedInt() -> Int {
        Int(rounded())
    }
}

extension Array {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Self.Element: Equatable {

    public func element(after element: Element) -> Element? {
        self.element(after: element, distance: 1)
    }

    public func element(before element: Element) -> Element? {
        self.element(after: element, distance: -1)
    }

    private func element(after element: Element, distance: Int) -> Element? {
        let index = firstIndex(of: element)
        let nextIndex = index.map { $0 + distance }
        return nextIndex.flatMap { self[safe: $0] }
    }
}
