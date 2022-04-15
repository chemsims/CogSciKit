//
// CogSciKit
//

import SwiftUI

public struct CorePalette {
    private init() { }
    
    public static let orangeAccent = Color("orangeAccent", bundle: .module)
    public static let speechBubble = Color("speechBubble", bundle: .module)
    
    static let inactiveSpeechBubbleButton = Color("inactiveSpeechBubble", bundle: .module)
    
    
    public struct Slider {
        public static let bar = Color("sliderBar", bundle: .module)
        public static let enabledHandle = CorePalette.orangeAccent
        public static let disabledHandle = Color("disabledSliderHandle", bundle: .module)
    }
    
    public struct Quiz {
        
        private static let lightBlue = Color("quizLightBlue", bundle: .module)
        private static let darkBlue = Color("quizDarkBlue", bundle: .module)
        
        static let selectedDifficultyBackground = lightBlue
        static let selectedDifficultyBorder = darkBlue
        static let unselectedDifficultyCount = Color("quizUnselectedDifficultyCount", bundle: .module)
        
        static let progressBackground = Color("quizProgressBackground", bundle: .module)
        static let progressForeground = darkBlue
        
        static let tableEvenRow = Color("quizTableEvenRow", bundle: .module)
        static let tableOddRow = Color("quizTableOddRow", bundle: .module)
        static let tableCellBorder = Color("quizTableCellBorder", bundle: .module)
        
        static let infoIconBackground = lightBlue
        static let infoIconForeground = darkBlue
        
        static let correctAnswerBackground = Color("quizCorrectAnswerBackground", bundle: .module)
        static let wrongAnswerBackground = Color("quizWrongAnswerBackground", bundle: .module)
        static let disabledAnswerBackground = Color("quizDisabledAnswerBackground", bundle: .module)
        static let answerBackground = Color("quizAnswerBackground", bundle: .module)
        
        static let correctAnswerBorder = Color("quizCorrectAnswerBorder", bundle: .module)
        static let wrongAnswerBorder = Color("quizWrongAnswerBorder", bundle: .module)
        
        static let reviewCorrectAnswerFont = Color("quizReviewCorrectAnswerFont", bundle: .module)
        static let reviewWrongAnswerFont = Color("quizReviewWrongAnswerFont", bundle: .module)
    }
}
