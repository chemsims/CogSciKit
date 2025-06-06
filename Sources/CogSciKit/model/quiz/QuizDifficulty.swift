//
// CogSciKit
//

import Foundation

public enum QuizDifficulty: Int, CaseIterable, Comparable, Codable {

    case easy, medium, hard

    public var quizLimit: Int? {
        switch self {
        case .easy: return 5
        case .medium: return 10
        case .hard: return nil
        }
    }

    public var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    public static func < (lhs: QuizDifficulty, rhs: QuizDifficulty) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public static func from(string: String) -> QuizDifficulty? {
        switch string.lowercased() {
        case "easy": return .easy
        case "medium": return .medium
        case "hard": return .hard
        default: return nil
        }
    }
}

extension QuizDifficulty {

    public static func availableQuestions(
        at difficulty: QuizDifficulty,
        questions: [QuizQuestion]
    ) -> [QuizQuestion] {
        guard let limit = difficulty.quizLimit else {
            return questions
        }

        func loop(_ diffToInclude: QuizDifficulty) -> [QuizQuestion] {
            let available = questions.filter { $0.difficulty <= diffToInclude }
            let filtered = Array(available.prefix(limit))
            let requiresMore = filtered.count < limit
            if requiresMore,
               let nextDiff = QuizDifficulty.allCases.element(after: diffToInclude) {
                return loop(nextDiff)
            } else {
                return filtered
            }
        }

        return loop(difficulty)
    }

    static func counts(questions: [QuizQuestion]) -> [QuizDifficulty: Int] {
        let allCounts = QuizDifficulty.allCases.map { difficulty in
            (difficulty, questions.filter { $0.difficulty == difficulty }.count)
        }

        var result = [QuizDifficulty: Int]()
        result[QuizDifficulty.easy] = allCounts.first!.1
        (1..<QuizDifficulty.allCases.count).forEach { i in
            let difficulty = QuizDifficulty.allCases[i]
            let difficultyCount = allCounts[i].1
            if difficultyCount == 0 {
                result[difficulty] = 0
            } else {
                let previousNonZeroDifficultyIndex = stride(from: i - 1, through: 0, by: -1).first { i in
                    let prevDifficulty = QuizDifficulty.allCases[i]
                    return (result[prevDifficulty] ?? 0) > 0
                }

                let previousDifficultyCount: Int? = previousNonZeroDifficultyIndex.flatMap { i in
                    let prevDifficulty = QuizDifficulty.allCases[i]
                    return result[prevDifficulty]
                }

                result[difficulty] = difficultyCount + (previousDifficultyCount ?? 0)
            }
        }
        return result
    }
}
