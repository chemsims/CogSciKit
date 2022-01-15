//
// CogSciKit
//

import XCTest
@testable import CogSciKit

class SwiftExtensionTests: XCTestCase {
    
    func testValueWithinTwoLimits() {
        XCTAssertEqual(5.within(min: 0, max: 6), 5)
        XCTAssertEqual(5.within(min: 0, max: 4), 4)
        XCTAssertEqual(5.within(min: 6, max: 7), 6)
        XCTAssertEqual(5.within(min: 8, max: 8), 8)
    }
    
}
