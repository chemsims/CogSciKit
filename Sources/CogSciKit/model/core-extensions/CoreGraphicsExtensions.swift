//
// CogSciKit
//  

import CoreGraphics
import SwiftUI

extension CGFloat {
    public func str(decimals: Int) -> String {
        String.fromFloat(self, decimals: decimals)
    }

    public func rounded(decimals: Int) -> CGFloat {
        let power = pow(10, CGFloat(decimals))
        let multiplied = self * power
        let rounded = multiplied.rounded()
        return rounded / power
    }
}

extension CGPoint {
    public func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: self.x + dx, y: self.y + dy)
    }

    public func offset(_ size: CGSize) -> CGPoint {
        self.offset(dx: size.width, dy: size.height)
    }
    
    /// Returns a new point which is offset by the given `length` along the given `angle`.
    public func offset(length: CGFloat, angle: Angle) -> CGPoint {
        CGPoint(
            x: self.x + (length * cos(angle.radians)),
            y: self.y + (length * sin(angle.radians))
        )
    }
    
    /// Returns the point as a size.
    public var asSize: CGSize {
        CGSize(width: x, height: y)
    }
    
    /// Reverses the direction of the point.
    public var reversed: CGPoint {
        CGPoint(x: -x, y: -y)
    }
    
    /// Returns a point in the same physical location, but measured from an origin
    /// which has been moved by `offset`.
    ///
    ///     let point = CGPoint(x: 10, y: 10)
    ///     let adjusted = point.moveOrigin(by: CGSize(width: 20, height: 20)
    ///     print(adjusted)
    ///     // prints CGPoint(x: -10, y: -10)
    ///
    /// Notice that `adjusted` refers to the same physical location, but only when measured from an
    /// origin which is a distance `offset` away from the origin of the original point.
    /// ```
    public func moveOrigin(by offset: CGSize) -> CGPoint {
        let dx = -offset.width
        let dy = -offset.height
        return self.offset(dx: dx, dy: dy)
    }
}

extension CGSize {
    public func scaled(by factor: CGFloat) -> CGSize {
        CGSize(
            width: width * factor,
            height: height * factor
        )
    }
}

extension CGRect {
    public var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
