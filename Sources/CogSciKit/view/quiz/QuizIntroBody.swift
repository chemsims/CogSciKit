//
// CogSciKit
//

import SwiftUI

struct QuizIntroBody<QP: QuizPersistence, Analytics: AppAnalytics>: View where QP.QuestionSet == Analytics.QuestionSet {

    let settings: QuizLayoutSettings
    @ObservedObject var model: QuizViewModel<QP, Analytics>

    var body: some View {
        VStack {
            header
            HStack {
                Spacer()
                Button(action: model.skip) {
                    Text("Skip Quiz")
                        .font(.system(size: settings.skipFontSize, weight: .medium))
                        .foregroundColor(CorePalette.orangeAccent)
                }
            }
            ForEach(model.availableDifficulties, id: \.rawValue) { difficulty in
                quizDifficultyOption(difficulty: difficulty)
            }
        }
        .minimumScaleFactor(0.5)
    }

    private var header: some View {
        let heading = "Let's take a quiz"
        let subHeading = "Choose the difficulty level of the quiz"
        return VStack {
            Text(heading)
                .font(.system(size: settings.fontSize))
            Text(subHeading)
                .font(.system(size: settings.h2FontSize))
        }
        .accessibilityElement()
        .accessibility(addTraits: .isHeader)
        .accessibility(label: Text("\(heading), \(subHeading)"))
    }

    private func quizDifficultyOption(
        difficulty: QuizDifficulty
    ) -> some View {
        let isSelected = model.quizDifficulty == difficulty

        return ZStack {
            RoundedRectangle(cornerRadius: settings.progressCornerRadius)
                .foregroundColor(isSelected ? CorePalette.Quiz.selectedDifficultyBackground : .white)
                .shadow(radius: 2)

            if isSelected {
                RoundedRectangle(cornerRadius: settings.progressCornerRadius)
                    .strokeBorder(lineWidth: settings.activeLineWidth)
                    .foregroundColor(CorePalette.Quiz.selectedDifficultyBorder)
            }

            Text(difficulty.displayName)
                .font(.system(size: settings.fontSize, weight: .bold))
                .foregroundColor(
                    isSelected ? CorePalette.Quiz.selectedDifficultyBorder : .black
                )
            questionCount(difficulty.quizLimit ?? model.maxQuizLength)
                .foregroundColor(
                    isSelected ? CorePalette.Quiz.selectedDifficultyBorder : CorePalette.Quiz.unselectedDifficultyCount
                )
        }.onTapGesture {
            model.quizDifficulty = difficulty
        }
        .accessibilityElement()
        .accessibility(addTraits: .isButton)
        .accessibility(addTraits: isSelected ? .isSelected : [])
        .accessibility(label: Text("\(difficulty.displayName), \(model.quizLength) questions"))
    }

    private func questionCount(_ count: Int) -> some View {
        VStack {
            Spacer()
            HStack {
                Text("\(count) questions")
                    .font(.system(size: 0.55 * settings.fontSize, weight: .semibold))
                    .padding(2 * settings.progressCornerRadius)
                Spacer()
            }
        }
    }
}
