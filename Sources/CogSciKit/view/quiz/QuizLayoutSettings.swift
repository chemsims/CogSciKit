//
// CogSciKit
//

import SwiftUI

public struct QuizLayoutSettings {
    let geometry: GeometryProxy
    let horizontalSizeClass: UserInterfaceSizeClass?
    let verticalSizeClass: UserInterfaceSizeClass?
    
    public static func progressBarHeight(geometry: GeometryProxy) -> CGFloat {
        let layout = QuizLayoutSettings(geometry: geometry, horizontalSizeClass: nil, verticalSizeClass: nil)
        return layout.progressHeight + (2 * layout.progressBarPadding)
    }

    var width: CGFloat {
        geometry.size.width
    }

    var progressWidth: CGFloat {
        0.8 * geometry.size.width
    }

    var contentWidth: CGFloat {
        geometry.size.width - (2 * navTotalWidth)
    }

    var progressHeight: CGFloat {
        0.03 * geometry.size.height
    }

    var progressCornerRadius: CGFloat {
        0.01 * geometry.size.height
    }

    var navSize: CGFloat {
        0.05 * geometry.size.width
    }

    var navPadding: CGFloat {
        0.5 * navSize
    }

    var leftNavSize: CGFloat {
        0.4 * navTotalWidth
    }

    var rightNavSize: CGFloat {
        leftNavSize + (2 * leftNavPadding)
    }

    var leftNavPadding: CGFloat {
        0.5 * (navTotalWidth - leftNavSize)
    }

    var rightNavPadding: CGFloat {
        0.12 * rightNavSize
    }

    var navTotalWidth: CGFloat {
        0.15 * width
    }

    var questionFontSize: CGFloat {
        min(0.05 * geometry.size.height, 30)
    }

    var answerFontSize: CGFloat {
        0.9 * questionFontSize
    }

    var fontSize: CGFloat {
        min(0.04 * geometry.size.width, 44)
    }

    var h2FontSize: CGFloat {
        0.7 * fontSize
    }

    var progressFontSize: CGFloat {
        0.6 * fontSize
    }

    var progressLabelWidth: CGFloat {
        6 * progressHeight
    }

    var progressBarPadding: CGFloat {
        0.4 * navSize
    }

    var activeLineWidth: CGFloat {
        3
    }

    var standardLineWidth: CGFloat {
        1
    }

    var maxImageHeight: CGFloat {
        0.8 * geometry.size.height
    }

    var retryIconWidth: CGFloat {
        progressHeight
    }

    var retryLabelWidth: CGFloat {
        2 * retryIconWidth
    }

    var retryPadding: CGFloat {
        0.1 * retryIconWidth
    }

    var retryLabelFontSize: CGFloat {
        0.8 * answerFontSize
    }

    var skipFontSize: CGFloat {
        0.55 * fontSize
    }

    var questionReviewPadding: CGFloat {
        2
    }

    var tableWidthReviewCard: CGFloat {
        0.95 * tableWidthQuestionCard
    }

    var tableWidthQuestionCard: CGFloat {
        contentWidth
    }
}
