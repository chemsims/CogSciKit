//
// CogSciKit
//

import Foundation

/// A property wrapped to represent a fraction between 0 and 1
@propertyWrapper public struct Fractioned {
    
    public init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue.within(min: 0, max: 1)
    }
    
    public var wrappedValue: Double {
        didSet {
            wrappedValue = wrappedValue.within(min: 0, max: 1)
        }
    }
}
