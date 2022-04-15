//
// CogSciKit
//

import SwiftUI

extension View {
    public func accessibilitySetCurrentTimeAction(
        currentTime: Binding<CGFloat>,
        canSetTime: Bool,
        initialTime: CGFloat,
        finalTime: CGFloat
    )-> some View {
        self.modifier(
            AccessibilitySetCurrentTimeViewModifier(
                currentTime: currentTime,
                canSetTime: canSetTime,
                initialTime: initialTime,
                finalTime: finalTime
            )
        )
        .disabled(!canSetTime)
    }
}

private struct AccessibilitySetCurrentTimeViewModifier: ViewModifier {
    @Binding var currentTime: CGFloat
    let canSetTime: Bool
    let initialTime: CGFloat
    let finalTime: CGFloat

    func body(content: Content) -> some View {
        content.accessibilityAdjustableAction { direction in
            guard canSetTime else {
                return
            }
            let dt = finalTime - initialTime
            let increment = dt / 10
            let sign: CGFloat = direction == .increment ? 1 : -1
            let newValue = currentTime + (sign * increment)
            currentTime = min(finalTime, max(newValue, initialTime))
        }
    }
}
