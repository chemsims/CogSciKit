//
// CogSciKit
//

import SwiftUI

struct ProgressBar: View {

    let progress: CGFloat
    let progressColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                pill
                    .foregroundColor(backgroundColor)

                pill
                    .foregroundColor(progressColor)
                    .mask(progressMask(geometry: geometry))
            }
        }
    }

    private func progressMask(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: progress * geometry.size.width)
            Spacer()
                .frame(width: (1 - progress) * geometry.size.width)
        }
    }

    private var pill: some Shape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(
            progress: 0.9,
            progressColor: CorePalette.orangeAccent,
            backgroundColor: CorePalette.Quiz.progressBackground,
            cornerRadius: 10
        ).frame(height: 50)
    }
}
