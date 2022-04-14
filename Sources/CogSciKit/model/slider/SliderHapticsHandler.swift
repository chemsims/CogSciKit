//
// CogSciKit
//

import UIKit

private let defaultPreparationBufferPercentage: CGFloat = 0.1

public struct SliderHapticsHandler<Value: BinaryFloatingPoint> {
    
    let minValue: Value
    let maxValue: Value
    let impactGenerator:UIImpactFeedbackGenerator
    private let upperValueToPrepareGenerator: Double
    private let lowerValueToPrepareGenerator: Double

    internal init(
        minValue: Value,
        maxValue: Value,
        impactGenerator: UIImpactFeedbackGenerator,
        preparationBufferPercentage: Double
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.impactGenerator = impactGenerator
        let changeInValue = maxValue - minValue
        let absolutePreparationBuffer = preparationBufferPercentage * Double(changeInValue)
        self.upperValueToPrepareGenerator = Double(maxValue) - absolutePreparationBuffer
        self.lowerValueToPrepareGenerator = Double(minValue) + absolutePreparationBuffer
    }

    /// Triggers a haptic impact when the `newValue` exceeds the axis limits, and
    /// prepares the generator when value is close to the limits.
    public func valueDidChange(
        newValue: Value,
        oldValue: Value
    ) {
        if newValue > oldValue {
            if newValue >= maxValue {
                impactGenerator.impactOccurred()
            } else if Double(newValue) >= upperValueToPrepareGenerator {
                impactGenerator.prepare()
            }
        } else if newValue < oldValue {
            if newValue <= minValue {
                impactGenerator.impactOccurred()
            } else if Double(newValue) <= lowerValueToPrepareGenerator {
                impactGenerator.prepare()
            }
        }
    }
}

extension SliderHapticsHandler {
    /// Creates a haptics handler which may prepare or fire the underlying `impactGenerator` when
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
    
    /// Creates a haptics handler which may prepare or fire the underlying `impactGenerator` when
    /// `valueDidChange` is called.
    ///
    /// - Parameters:
    ///   - axis: The axis of the slider.
    ///   - impactGenerator: The haptic feedback generator.
    public init(
        minValue: Value,
        maxValue: Value,
        impactGenerator: UIImpactFeedbackGenerator
    ) {
        self.init(
            minValue: minValue,
            maxValue: maxValue,
            impactGenerator: impactGenerator,
            preparationBufferPercentage: defaultPreparationBufferPercentage
        )
    }
    
    internal init(
        axis: LinearAxis<Value>,
        impactGenerator: UIImpactFeedbackGenerator,
        preparationBufferPercentage: Double
    ) {
        self.init(
            minValue: axis.minValue,
            maxValue: axis.maxValue,
            impactGenerator: impactGenerator,
            preparationBufferPercentage: preparationBufferPercentage
        )
    }
}
