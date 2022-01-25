//
// CogSciKit
//

import XCTest
import CogSciKit

class SwiftExtensionTests: XCTestCase {
    
    func testValueWithinTwoLimits() {
        XCTAssertEqual(5.within(min: 0, max: 6), 5)
        XCTAssertEqual(5.within(min: 0, max: 4), 4)
        XCTAssertEqual(5.within(min: 6, max: 7), 6)
        XCTAssertEqual(5.within(min: 8, max: 8), 8)
    }
    
    func testStringFromFloat() {
        XCTAssertEqual(String.fromFloat(123.456, decimals: 1), "123.5")
        XCTAssertEqual(String.fromFloat(-100.001, decimals: 0), "-100")
        XCTAssertEqual(String.fromFloat(0.001, decimals: 3), "0.001")
        XCTAssertEqual(String.fromFloat(-0.001, decimals: 3), "-0.001")
        XCTAssertEqual(String.fromFloat(1.23, decimals: 0), "1")
        XCTAssertEqual(String.fromFloat(1.23, decimals: 1), "1.2")
        XCTAssertEqual(String.fromFloat(1.23, decimals: 2), "1.23")
        XCTAssertEqual(String.fromFloat(1.23, decimals: 3), "1.230")
    }
    
    func testStringFromFloatForValuesWhichRoundToZero() {
        XCTAssertEqual(String.fromFloat(0, decimals: 0), "0")
        XCTAssertEqual(String.fromFloat(-0, decimals: 0), "0")
        
        XCTAssertEqual(String.fromFloat(0.0001, decimals: 1), "0.0")
        XCTAssertEqual(String.fromFloat(-0.0001, decimals: 1), "0.0")
        
        XCTAssertEqual(String.fromFloat(0.0001, decimals: 2), "0.00")
        XCTAssertEqual(String.fromFloat(-0.0001, decimals: 2), "0.00")
        
        XCTAssertEqual(String.fromFloat(0.0001, decimals: 3), "0.000")
        XCTAssertEqual(String.fromFloat(-0.0001, decimals: 3), "0.000")
    }
}
