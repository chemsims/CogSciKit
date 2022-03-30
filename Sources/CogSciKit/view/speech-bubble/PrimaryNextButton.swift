//
// CogSciKit
//

import SwiftUI

public struct PrimaryNextOrRetryButton: View {
    
    public init(actionType: Action, action: @escaping () -> Void) {
        self.actionType = actionType
        self.action = action
    }
    
    let actionType: Action
    let action: () -> Void
    
    public var body: some View {
        GeometryReader { geo in
            GeneralPrimaryButtonWithGeometry(
                name: actionType.name,
                imageName: actionType.imageName,
                iconUnitPadding: actionType.imageUnitPadding,
                action: action,
                geometry: geo
            )
        }
    }
    
    public enum Action: String {
        case next, retry
        
        var name: String {
            rawValue.capitalized
        }
        
        var imageName: String {
            switch self {
            case .next:
                return "arrowtriangle.right.fill"
            case .retry:
                return "arrow.counterclockwise"
            }
        }
        
        var imageUnitPadding: CGFloat {
            switch self {
            case .next:
                return 0.3
            case .retry:
                return 0.2
            }
        }
    }
}

public struct PrimaryNextButton: View {
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }

    let action: () -> Void

    public var body: some View {
        PrimaryNextOrRetryButton(actionType: .next, action: action)
    }
}

private struct GeneralPrimaryButtonWithGeometry: View {

    let name: String
    let imageName: String
    let iconUnitPadding: CGFloat
    let action: () -> Void
    let geometry: GeometryProxy
    @Environment(\.isEnabled) var isEnabled

    var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(SquashButtonStyle(scaleDelta: 0.02))
        .accessibility(label: Text(name))
        .disabled(isDisabled)
        .compositingGroup()
        .opacity(isDisabled ? 0.6 : 1)
        .animation(nil, value: name)
        .animation(nil, value: iconUnitPadding)
    }

    private var content: some View {
        ZStack(alignment: .trailing) {
            pill
            iconWithText
        }
    }

    private var pill: some View {
        ZStack {
            PillShape()
                .foregroundColor(CorePalette.speechBubble)

            PillShape()
                .strokeBorder(lineWidth: lineWidth)
                .foregroundColor(accentColor)
        }

    }

    private var iconWithText: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: height / 2)
            Text(name)
                .frame(width: width - (1.5 * height))
                .foregroundColor(accentColor)
                .font(.system(size: fontSize, weight: .semibold))
                .minimumScaleFactor(0.5)
            icon
        }
        .frame(width: width)
    }

    private var icon: some View {
        ZStack {
            Circle()
                .foregroundColor(accentColor)

            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(CorePalette.speechBubble)
                .padding(iconPadding)
        }
        .frame(width: height, height: height)
    }

    private var accentColor: Color {
        isDisabled ? CorePalette.inactiveSpeechBubbleButton : CorePalette.orangeAccent
    }
    
    private var isDisabled: Bool { !isEnabled }
}

private extension GeneralPrimaryButtonWithGeometry {
    var width: CGFloat {
        geometry.size.width
    }

    var height: CGFloat {
        geometry.size.height
    }

    var lineWidth: CGFloat {
        0.08 * height
    }

    var iconPadding: CGFloat {
        iconUnitPadding * height
    }

    var fontSize: CGFloat {
        0.6 * height
    }
}

struct PrimaryNextButton_Previews: PreviewProvider {
    static var previews: some View {
        ViewWrapper()
    }
    
    private struct ViewWrapper: View {
        @State var actionType = PrimaryNextOrRetryButton.Action.retry
        
        var body: some View {
            VStack {
                PrimaryNextOrRetryButton(actionType: actionType, action: {})
                    .frame(width: 200, height: 50)
                
                PrimaryNextButton(action: {})
                    .frame(width: 200, height: 50)

                PrimaryNextButton(action: {})
                    .frame(width: 200, height: 50)
                    .disabled(true)
                
                Button("Toggle action type") {
                    withAnimation {
                        actionType = actionType == .next ? .retry : .next
                    }
                }
            }
        }
    }
}
