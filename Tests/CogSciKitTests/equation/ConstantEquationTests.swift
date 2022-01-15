//
// CogSciKit
//
import XCTest
import CogSciKit

class ConstantEquationTests: XCTestCase {
    func testConstantEquationReturnsConstantValue() {
        let equation = ConstantEquation(value: 5)
        XCTAssertEqual(equation.getValue(at: 0), 5)
        XCTAssertEqual(equation.getValue(at: 1), 5)
        XCTAssertEqual(equation.getValue(at: 2), 5)
    }
}
