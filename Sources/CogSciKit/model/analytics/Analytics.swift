//
// CogSciKit
//

import Foundation

public protocol AppAnalytics {
    associatedtype Screen
    associatedtype QuestionSet

    func opened(screen: Screen)

    var enabled: Bool { get }
    func setEnabled(value: Bool)

    func answeredQuestion(
        questionSet: QuestionSet,
        questionId: String,
        answerId: String,
        answerAttempt: Int,
        isCorrect: Bool
    )

    func startedQuiz(questionSet: QuestionSet, difficulty: QuizDifficulty)

    func completedQuiz(
        questionSet: QuestionSet,
        difficulty: QuizDifficulty,
        percentCorrect: Double
    )
}
