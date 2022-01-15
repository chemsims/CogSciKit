//
// CogSciKit
//

import SwiftUI

public struct NextButton: View {

    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        GeneralDirectionButton(
            action: action,
            systemImage: "arrowtriangle.right.fill"
        )
        .accessibility(label: Text("Next"))
    }
}

public struct PreviousButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        GeneralDirectionButton(
            action: action,
            systemImage: "arrowtriangle.left.fill"
        )
        .accessibility(label: Text("Back"))
    }
}

private struct GeneralDirectionButton: View {
    let action: () -> Void
    let systemImage: String

    var body: some View {
        CircleIconButton(
            action: action,
            systemImage: systemImage,
            background: CorePalette.speechBubble,
            border: CorePalette.speechBubble,
            foreground: Color.black
        )
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            PreviousButton(
                action: {}
            )
            NextButton(
                action: {}
            )
        }
    }
}
