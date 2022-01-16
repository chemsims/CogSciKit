//
// CogSciKit
//

import XCTest
@testable import CogSciKit

class FractionedPropertyWrapperTests: XCTestCase {
    
    func testFractionedPropertyWrapper() {
        @Fractioned var value = -1
                
        XCTAssertEqual(value, 0)
        
        value = 2
        XCTAssertEqual(value, 1)
        
        value = 0.5
        XCTAssertEqual(value, 0.5)
    }
}
