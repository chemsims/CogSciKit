//
// CogSciKit
//

import CoreGraphics

public struct ScaledEquation: Equation {

    public let scaleFactor: CGFloat
    public let underlying: Equation

    public init(targetY: CGFloat, targetX: CGFloat, underlying: Equation) {
        let currentY = underlying.getValue(at: targetX)
        self.scaleFactor = currentY == 0 ? 1 : targetY / currentY
        self.underlying = underlying
    }

    public func getValue(at input: CGFloat) -> CGFloat {
        scaleFactor * underlying.getValue(at: input)
    }
}
