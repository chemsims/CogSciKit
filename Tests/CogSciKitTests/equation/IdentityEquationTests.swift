//
// CogSciKit
//

import XCTest
import CogSciKit

class IdentityEquationTests: XCTestCase {
    
    func testIdentityEquationReturnsTheInputValue() {
        let equation = IdentityEquation()
        XCTAssertEqual(equation.getValue(at: 0), 0)
        XCTAssertEqual(equation.getValue(at: 1), 1)
        XCTAssertEqual(equation.getValue(at: 2), 2)
    }

}
