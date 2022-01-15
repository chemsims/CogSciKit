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
