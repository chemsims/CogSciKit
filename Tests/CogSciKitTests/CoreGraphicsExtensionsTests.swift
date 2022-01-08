//
//  CogSciKit
//  

import XCTest
@testable import CogSciKit

class CoreGraphicsExtensionsTests: XCTestCase {
    
    func testOffsetOfAPoint() {
        XCTAssertEqual(CGPoint.zero.offset(dx: 30, dy: 40), CGPoint(x: 30, y: 40))
        XCTAssertEqual(CGPoint.zero.offset(dx: -50, dy: 100), CGPoint(x: -50, y: 100))
        XCTAssertEqual(CGPoint.zero.offset(CGSize(width: 100, height: -200)), CGPoint(x: 100, y: -200))
    }
    
    func testScalingACGSize() {
        XCTAssertEqual(CGSize(width: 10, height: 20).scaled(by: 2), CGSize(width: 20, height: 40))
        XCTAssertEqual(CGSize(width: -30, height: -50).scaled(by: 0.1), CGSize(width: -3, height: -5))
        XCTAssertEqual(CGSize(width: -30, height: 100).scaled(by: 0), CGSize(width: 0, height: 0))
    }
    
}
