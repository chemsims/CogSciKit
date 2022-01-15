//
// CogSciKti
//

import CoreGraphics

struct AnonymousEquation: Equation {
    let transform: (CGFloat) -> CGFloat

    func getValue(at input: CGFloat) -> CGFloat {
        transform(input)
    }
}
