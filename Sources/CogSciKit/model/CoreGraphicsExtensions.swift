//
//  CogSciKit
//  

import CoreGraphics
import SwiftUI

extension CGPoint {
    public func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        CGPoint(x: self.x + dx, y: self.y + dy)
    }

    public func offset(_ size: CGSize) -> CGPoint {
        self.offset(dx: size.width, dy: size.height)
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
