//
// CogSciKit
//

import XCTest
import CogSciKit

class FunctionalExtensionsTests: XCTestCase {
    
    func testOptionalForAll() {
        var opt: Int? = nil
        XCTAssert(opt.forAll { $0 > 0 })
        
        opt = 1
        
        XCTAssert(opt.forAll { $0 > 0 })
        XCTAssertFalse(opt.forAll { $0 < 0 })
    }
    
    func testOptionalExists() {
        var opt: Int? = nil
        XCTAssertFalse(opt.exists { $0 > 0 })
        
        opt = 1
        XCTAssert(opt.forAll { $0 > 0 })
        XCTAssertFalse(opt.forAll { $0 < 0 })
    }
    
    func testOptionalContains() {
        var opt: Int? = nil
        XCTAssertFalse(opt.contains(1))
        
        opt = 1
        XCTAssert(opt.contains(1))
        XCTAssertFalse(opt.contains(2))
    }

    func testFlatteningArray() {
        XCTAssertEqual([[1], [2]].flatten, [1, 2])
        XCTAssertEqual([[1, 2], [3]].flatten, [1, 2, 3])
        XCTAssertEqual([[1, 2], [3, 4, 5]].flatten, [1, 2, 3, 4, 5])
        XCTAssertEqual([[1], [2], [], [3]].flatten, [1, 2, 3])
        XCTAssertEqual([[], [2], [3,4,5], [6]].flatten, [2, 3, 4, 5, 6])
        XCTAssert([[]].flatten.isEmpty)
    }

}
