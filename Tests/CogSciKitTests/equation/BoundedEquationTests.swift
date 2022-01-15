//
// CogSciKit
//

import XCTest
import CogSciKit

class BoundEquationTests: XCTestCase {
    
    func testCreatingABoundEquationWithNoLimits() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = BoundEquation(underlying: underlying, lowerBound: nil, upperBound: nil)
        XCTAssertEqual(equation.getValue(at: -1), -2)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 2)
    }
    
    func testCreatingABoundEquationWithOnlyALowerLimit() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = BoundEquation(underlying: underlying, lowerBound: -1, upperBound: nil)
        XCTAssertEqual(equation.getValue(at: -2), -1)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 2)
    }
    
    func testCreatingABoundEquationWithOnlyAnUpperLimit() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = BoundEquation(underlying: underlying, lowerBound: nil, upperBound: 1)
        XCTAssertEqual(equation.getValue(at: -1), -2)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 1)
    }
    
    func testCreatingABoundEquationWithBothLimitsUsingConvenienceMethod() {
        let equation = LinearEquation(m: 2, x1: 0, y1: 0).within(min: -1, max: 1)
        XCTAssertEqual(equation.getValue(at: -1), -1)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 1)
        XCTAssertEqual(equation.getValue(at: 2), 1)
    }
    
    func testCreatingABoundInputEquationWithNoLimits() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = BoundInputEquation(underlying: underlying, lowerBound: nil, upperBound: nil)
        XCTAssertEqual(equation.getValue(at: -1), -2)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 2)
    }
    
    func testCreatingABoundInputEquationWithOnlyALowerLimit() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = BoundInputEquation(underlying: underlying, lowerBound: -1, upperBound: nil)
        XCTAssertEqual(equation.getValue(at: -1), -2)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 2)
    }
    
    func testCreatingABoundInputEquationWithOnlyAnUpperLimit() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = BoundInputEquation(underlying: underlying, lowerBound: nil, upperBound: 1)
        XCTAssertEqual(equation.getValue(at: -1), -2)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 2)
        XCTAssertEqual(equation.getValue(at: 2), 2)
    }
    
    func testCreatingABoundInputEquationWithBothLimitsUsingConvenienceMethod() {
        let underlying = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation = underlying.inputWithin(min: -1, max: 1)
        
        XCTAssertEqual(equation.getValue(at: -2), -2)
        XCTAssertEqual(equation.getValue(at: -1), -2)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 2)
        XCTAssertEqual(equation.getValue(at: 2), 2)
    }
}
