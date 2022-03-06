//
// CogSciKit
//

import XCTest
@testable import CogSciKit

class SliderHapticsHandlerTests: XCTestCase {

    func testThatAnImpactOccursOnceWhenTheValueExceedsTheMaximum() {
        let generator = MockUIImpactFeedbackGenerator()
        let handler = SliderHapticsHandler(
            axis: LinearAxis(minValuePosition: 0, maxValuePosition: 1, minValue: 0, maxValue: 1),
            impactGenerator: generator
        )
        
        handler.valueDidChange(newValue: 1.1, oldValue: 0)
        XCTAssertEqual(generator.impacts, 1)
        
        handler.valueDidChange(newValue: 1.1, oldValue: 1.1)
        XCTAssertEqual(generator.impacts, 1)
    }

    func testThatAnImpactOccursOnceWhenTheValueIsLessThanTheMinimum() {
        let generator = MockUIImpactFeedbackGenerator()
        let handler = SliderHapticsHandler(
            axis: LinearAxis(minValuePosition: 0, maxValuePosition: 1, minValue: 0, maxValue: 1),
            impactGenerator: generator
        )
        
        handler.valueDidChange(newValue: -0.1, oldValue: 0)
        XCTAssertEqual(generator.impacts, 1)
        
        handler.valueDidChange(newValue: -0.1, oldValue: -0.1)
        XCTAssertEqual(generator.impacts, 1)
    }
    
    func testTheGeneratorIsPreparedWhenCloseToTheMaximum() {
        let generator = MockUIImpactFeedbackGenerator()
        let handler = SliderHapticsHandler(
            axis: LinearAxis(minValuePosition: 0, maxValuePosition: 1, minValue: 0, maxValue: 1),
            impactGenerator: generator,
            preparationBufferPercentage: 0.2
        )
        
        handler.valueDidChange(newValue: 0.8, oldValue: 0)
        XCTAssertEqual(generator.preparations, 1)
    }
    
    func testTheGeneratorIsPreparedWhenCloseToTheMinimum() {
        let generator = MockUIImpactFeedbackGenerator()
        let handler = SliderHapticsHandler(
            axis: LinearAxis(minValuePosition: 0, maxValuePosition: 1, minValue: 0, maxValue: 1),
            impactGenerator: generator,
            preparationBufferPercentage: 0.2
        )
        
        handler.valueDidChange(newValue: 0.2, oldValue: 1)
        XCTAssertEqual(generator.preparations, 1)
    }
    
    
}

private class MockUIImpactFeedbackGenerator: UIImpactFeedbackGenerator {
    
    private(set) var impacts = 0
    private(set) var preparations = 0
    
    override func impactOccurred() {
        impacts += 1
    }
    
    override func prepare() {
        preparations += 1
    }
}
