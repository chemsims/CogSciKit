//
// CogSciKit
//  

import Foundation

public enum QuizOption: String, CaseIterable, Equatable {
    case A, B, C, D
}

extension QuizOption: Comparable {
    public static func < (lhs: QuizOption, rhs: QuizOption) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var label: String {
        switch self {
        case .A: return "1"
        case .B: return "2"
        case .C: return "3"
        case .D: return "4"
        }
    }
}
