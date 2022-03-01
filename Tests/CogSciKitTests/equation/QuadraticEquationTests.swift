//
// CogSciKit
//

import XCTest
import CogSciKit

class QuadraticEquationTests: XCTestCase {

    func testFindingRootsWhenTheSquareRootTermIsZero() {
        let roots = QuadraticEquation.roots(a: 1, b: 2, c: 1)
        XCTAssertEqual(roots?.0, -1)
        XCTAssertEqual(roots?.1, -1)
    }

}
