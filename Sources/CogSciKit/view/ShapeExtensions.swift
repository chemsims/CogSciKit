//
//  CogSciKit
//  

import SwiftUI

extension Shape {
    public func strokeAndFill() -> some View {
        ZStack {
            self
                .fill()
            
            self
                .stroke()
        }
    }
}
