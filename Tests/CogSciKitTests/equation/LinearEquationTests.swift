//
// CogSciKit
//

import XCTest
import CogSciKit

class LinearEquationTests: XCTestCase {
    func testCreatingLinearEquationWithExplicitGradientAndIntercept1() {
        let equation = LinearEquation(m: 5, x1: 0, y1: 0)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 5)
        XCTAssertEqual(equation.getValue(at: 2), 10)
    }
    
    func testCreatingLinearEquationWithExplicitGradientAndIntercept2() {
        let equation = LinearEquation(m: 5, x1: 2, y1: 5)
        XCTAssertEqual(equation.getValue(at: 0), -5)
        XCTAssertEqual(equation.getValue(at: 1), 0)
        XCTAssertEqual(equation.getValue(at: 2), 5)
    }
    
    func testCreatingLinearEquationWithTwoPoints() {
        let equation = LinearEquation(x1: -1, y1: 5, x2: 1, y2: -5)
        XCTAssertEqual(equation.getValue(at: -1), 5)
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), -5)
    }
    
    func testGettingTheXValueForAGivenY() {
        let equation = LinearEquation(m: 2, x1: 0, y1: 0)
        XCTAssertEqual(equation.getX(at: 4), 2)
    }
    
    func testGettingTheXValueForAGivenYWhenGradientIsZero() {
        let equation = LinearEquation(m: 0, x1: 1, y1: 1)
        XCTAssertEqual(equation.getX(at: 2), 0)
    }
    
    func testFindingTheIntersectionPointOfTwoLinearEquations() {
        let equation1 = LinearEquation(m: 2, x1: 0, y1: 0)
        let equation2 = LinearEquation(m: 1, x1: 0, y1: 2)
        
        let expectedPoint = CGPoint(x: 2, y: 4)
        XCTAssertEqual(equation1.intersectionWith(other: equation2), expectedPoint)
        XCTAssertEqual(equation2.intersectionWith(other: equation1), expectedPoint)
    }
    
    func testFindingTheIntersectionPointOfTwoLinearEquationsWhichDontCross() {
        let equation1 = LinearEquation(m: 1, x1: 0, y1: 0)
        let equation2 = LinearEquation(m: 1, x1: 0, y1: 1)
        XCTAssertNil(equation1.intersectionWith(other: equation2))
        XCTAssertNil(equation2.intersectionWith(other: equation1))
    }
}
