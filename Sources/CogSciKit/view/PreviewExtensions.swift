//
//  CogSciKit
//

import SwiftUI

extension View {
    
    @ViewBuilder
    /// Override orientation of the preview if possible, or falls back to original view for older iOS versions.
    public func previewLandscape() -> some View {
        if #available(iOS 15.0, *) {
            self.previewInterfaceOrientation(.landscapeLeft)
        } else {
            self
        }
    }
}
