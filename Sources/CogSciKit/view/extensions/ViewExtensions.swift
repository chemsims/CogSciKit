//
// CogSciKit
//

import SwiftUI

extension View {
    public func frame(square size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height, alignment: alignment)
    }
    
    public func offset(length: CGFloat, direction: Angle) -> some View {
        self.offset(
            CGPoint.zero.offset(length: length, angle: direction).asSize
        )
    }
}
