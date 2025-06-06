//
// CogSciKit
//

import SwiftUI

public struct PlaceholderTerm: View {

    let value: String?
    let emphasise: Bool

    let boxWidth: CGFloat
    let boxHeight: CGFloat
    let boxPadding: CGFloat
    let boxLineWidth: CGFloat

    public init(
        value: String?,
        emphasise: Bool = false,
        boxWidth: CGFloat = EquationSizing.boxWidth,
        boxHeight: CGFloat = EquationSizing.boxHeight,
        boxPadding: CGFloat = EquationSizing.boxPadding,
        boxLineWidth: CGFloat = 1
    ) {
        self.value = value
        self.emphasise = emphasise
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.boxPadding = boxPadding
        self.boxLineWidth = boxLineWidth
    }

    public var body: some View {
        if value != nil {
            Text(value!)
                .modifier(PlaceholderFraming(boxWidth: boxWidth, boxHeight: boxHeight))
                .animation(.none)
                .foregroundColor(emphasise ? CorePalette.orangeAccent : .black)
                .accessibility(value: Text(value!))
        } else {
            Box(padding: boxPadding, lineWidth: boxLineWidth)
                .modifier(PlaceholderFraming(boxWidth: boxWidth, boxHeight: boxHeight))
                .accessibility(value: Text("Place-holder"))
        }
    }
}

public struct PlaceholderTextLine: View {
    public init(
        value: TextLine?,
        fontSize: CGFloat = EquationSizing.fontSize,
        expandedWidth: CGFloat = EquationSizing.boxWidth,
        boxWidth: CGFloat = EquationSizing.boxWidth,
        boxHeight: CGFloat = EquationSizing.boxHeight,
        boxPadding: CGFloat = EquationSizing.boxPadding,
        boxLineWidth: CGFloat = 1
    ) {
        self.value = value
        self.fontSize = fontSize
        self.expandedWidth = expandedWidth
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.boxPadding = boxPadding
        self.boxLineWidth = boxLineWidth
    }

    let value: TextLine?
    let fontSize: CGFloat

    let expandedWidth: CGFloat
    let boxWidth: CGFloat
    let boxHeight: CGFloat
    let boxPadding: CGFloat
    let boxLineWidth: CGFloat

    public var body: some View {
        if value != nil {
            TextLinesView(line: value!, fontSize: fontSize)
                .frame(width: expandedWidth, height: boxHeight)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .accessibilityElement(children: .ignore)
                .accessibility(value: Text(value!.label))
        } else {
            Box(padding: boxPadding, lineWidth: boxLineWidth)
                .frame(width: boxWidth, height: boxHeight)
                .minimumScaleFactor(0.5)
                .accessibility(value: Text("Place-holder"))
        }
    }
}

private struct PlaceholderFraming: ViewModifier {

    let boxWidth: CGFloat
    let boxHeight: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(
                width: boxWidth,
                height: boxHeight
            )
            .minimumScaleFactor(0.5)
    }
}

private struct Box: View {

    let padding: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        PlaceholderBox(lineWidth: lineWidth)
            .padding(padding)
    }
}

/// A box with a dashed border
public struct PlaceholderBox: View {

    public init(lineWidth: CGFloat = 1) {
        self.lineWidth = lineWidth
    }
    
    let lineWidth: CGFloat

    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .stroke(
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .square,
                        lineJoin: .round,
                        miterLimit: 0,
                        dash: dash2(geometry),
                        dashPhase: geometry.size.height / 6
                    )
                )
        }
    }

    // The dash array reads, [stroke-width, gap-width, stroke-width, ... ]
    // When the end of the array is met, it loops back to the start
    private func dash2(_ geometry: GeometryProxy) -> [CGFloat] {
        let d1 = geometry.size.width / 6
        let v1 = geometry.size.height / 6
        return [
            d1 + v1,    // Top left corner
            d1,         // Top, left gap
            2 * d1,     // Top edge
            d1,         // Top, right gap
            d1 + v1,    // Top right corner
            v1,         // Right, top gap
            2 * v1,     // Right edge
            v1          // Right, bottom gap
        ]
    }

    private func dash(_ geometry: GeometryProxy) -> [CGFloat] {
        let phase = dashPhase(geometry)
        return [2 * phase, phase]
    }

    private func dashPhase(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 6
    }

    private func smallHorizontal(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width / 6
    }
}

struct EquationPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlaceholderBox()
                .frame(width: 100, height: 100)

            PlaceholderBox()
                .frame(width: 100, height: 70)

            VStack(alignment: .trailing) {
                PlaceholderTextLine(value: nil)
                    .frame(width: 2 * EquationSizing.boxWidth, alignment: .trailing)

                PlaceholderTextLine(value: TextLine("1.24x10^-45^"))
                    .frame(width: 2 * EquationSizing.boxWidth)
            }
        }
    }
}
