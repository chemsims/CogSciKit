//
// CogSciKit
//

import CoreGraphics

public struct ConstantEquation: Equation {
    public let value: CGFloat

    public init(value: CGFloat) {
        self.value = value
    }
    
    public func getValue(at input: CGFloat) -> CGFloat {
        value
    }
}
