//
// CogSciKit
//

import SwiftUI

public struct SquashButtonStyle: ButtonStyle {

    let scaleDelta: CGFloat
    public init(scaleDelta: CGFloat = 0.1) {
        self.scaleDelta = scaleDelta
    }

    public func makeBody(configuration: Configuration) -> some View {
        let xScale = configuration.isPressed ? 1 + scaleDelta : 1
        let yScale = configuration.isPressed ? 1 - scaleDelta : 1
        return configuration
            .label
            .scaleEffect(x: xScale, y: yScale)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            RoundedRectangle(cornerRadius: 5)
        }
        .buttonStyle(SquashButtonStyle())
        .frame(width: 100, height: 50)
    }
}
