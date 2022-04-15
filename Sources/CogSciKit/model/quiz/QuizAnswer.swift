//
// CogSciKit
//

import Foundation

/// Definition of a quiz answer
public struct QuizAnswerData: Equatable {
    public let answer: TextLine
    public let explanation: TextLine
    public let position: QuizOption?

    public init(
        answer: String,
        answerLabel: String? = nil,
        explanation: String,
        position: QuizOption? = nil,
        explanationLabel: String? = nil
    ) {
        self.answer = TextLine(
            answer,
            label: Labelling.stringToLabel(answerLabel ?? answer)
        )
        self.explanation = TextLine(
            explanation,
            label: Labelling.stringToLabel(explanationLabel ?? explanation)
        )
        self.position = position
    }
}

/// Internal representation of a quiz answer
public struct QuizAnswer: Equatable {
    
    public init(answer: TextLine, explanation: TextLine, id: String) {
        self.answer = answer
        self.explanation = explanation
        self.id = id
    }
    
    public let answer: TextLine
    public let explanation: TextLine
    public let id: String
}
