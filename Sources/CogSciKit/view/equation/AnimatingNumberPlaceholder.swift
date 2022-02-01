//
// CogSciKit
//

import SwiftUI

public struct AnimatingNumberPlaceholder: View {

    public init(
        showTerm: Bool,
        progress: CGFloat,
        equation: Equation,
        boxWidth: CGFloat = EquationSizing.boxWidth,
        boxHeight: CGFloat = EquationSizing.boxHeight,
        boxPadding: CGFloat = EquationSizing.boxPadding,
        boxLineWidth: CGFloat = 1,
        formatter: @escaping (CGFloat) -> String = { $0.str(decimals: 2) }
    ) {
        self.showTerm = showTerm
        self.progress = progress
        self.equation = equation
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.boxPadding = boxPadding
        self.boxLineWidth = boxLineWidth
        self.formatter = formatter
    }

    let showTerm: Bool
    let progress: CGFloat
    let equation: Equation
    let boxWidth: CGFloat
    let boxHeight: CGFloat
    let boxPadding: CGFloat
    let boxLineWidth: CGFloat
    let formatter: (CGFloat) -> String

    
    public var body: some View {
        if showTerm {
            AnimatingNumber(
                x: progress,
                equation: equation,
                formatter: formatter
            )
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(CorePalette.orangeAccent)
        } else {
            PlaceholderTerm(
                value: nil,
                boxWidth: boxWidth,
                boxHeight: boxHeight,
                boxPadding: boxPadding,
                boxLineWidth: boxLineWidth
            )
        }
    }
}
