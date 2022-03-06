//
// CogSciKit
//

import UIKit

private let defaultPreparationBufferPercentage: CGFloat = 0.1

public struct SliderHapticsHandler<Value: BinaryFloatingPoint> {
    
    let axis: LinearAxis<Value>
    let impactGenerator:UIImpactFeedbackGenerator
    private let upperValueToPrepareGenerator: Double
    private let lowerValueToPrepareGenerator: Double

    /// Creates a haptics handler which may prepare or fires the underlying `impactGenerator` when
    /// `valueDidChange` is called.
    ///
    /// - Parameters:
    ///   - axis: The axis of the slider.
    ///   - impactGenerator: The haptic feedback generator.
    public init(
        axis: LinearAxis<Value>,
        impactGenerator: UIImpactFeedbackGenerator
    ) {
        self.init(
            axis: axis,
            impactGenerator: impactGenerator,
            preparationBufferPercentage: defaultPreparationBufferPercentage
        )
    }
    
    init(
        axis: LinearAxis<Value>,
        impactGenerator: UIImpactFeedbackGenerator,
        preparationBufferPercentage: Double
    ) {
        self.axis = axis
        self.impactGenerator = impactGenerator
        let changeInValue = axis.maxValue - axis.minValue
        let absolutePreparationBuffer = preparationBufferPercentage * Double(changeInValue)
        self.upperValueToPrepareGenerator = Double(axis.maxValue) - absolutePreparationBuffer
        self.lowerValueToPrepareGenerator = Double(axis.minValue) + absolutePreparationBuffer
    }

    /// Triggers a haptic impact when the `newValue` exceeds the axis limits, and
    /// prepares the generator when value is close to the limits.
    public func valueDidChange(
        newValue: Value,
        oldValue: Value
    ) {
        if newValue > oldValue {
            if newValue >= axis.maxValue {
                impactGenerator.impactOccurred()
            } else if Double(newValue) >= upperValueToPrepareGenerator {
                impactGenerator.prepare()
            }
        } else if newValue < oldValue {
            if newValue <= axis.minValue {
                impactGenerator.impactOccurred()
            } else if Double(newValue) <= lowerValueToPrepareGenerator {
                impactGenerator.prepare()
            }
        }
    }
}
