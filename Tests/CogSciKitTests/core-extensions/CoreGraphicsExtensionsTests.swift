//
// CogSciKit
//  

import XCTest
import CogSciKit

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
    
    func testReversingAPoint() {
        XCTAssertEqual(CGPoint(x: 0, y: 0).reversed, CGPoint(x: 0, y: 0))
        XCTAssertEqual(CGPoint(x: 20, y: 40).reversed, CGPoint(x: -20, y: -40))
        XCTAssertEqual(CGPoint(x: -20, y: -40).reversed, CGPoint(x: 20, y: 40))
    }
    
    func testMappingAPointToASize() {
        XCTAssertEqual(CGPoint(x: 0, y: 0).asSize, CGSize(width: 0, height: 0))
        XCTAssertEqual(CGPoint(x: 20, y: 40).asSize, CGSize(width: 20, height: 40))
        XCTAssertEqual(CGPoint(x: -20, y: -40).asSize, CGSize(width: -20, height: -40))
    }
    
    func testMovingAPointsOriginInTheXDirection() {
        let point = CGPoint(x: 40, y: 0)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: 0)).x, 40)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 10, height: 0)).x, 30)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 40, height: 0)).x, 0)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 100, height: 0)).x, -60)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: -10, height: 0)).x, 50)
    }
    
    func testMovingAPointsOriginInTheYDirection() {
        let point = CGPoint(x: 0, y: 50)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: 0)).y, 50)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: 20)).y, 30)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: 50)).y, 0)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: 60)).y, -10)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: -30)).y, 80)
    }
    
    func testMovingAPointsOriginInBothDirections() {
        let point = CGPoint(x:40, y: 50)
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 0, height: 0)), CGPoint(x: 40, y: 50))
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: 10, height: 20)), CGPoint(x: 30, y: 30))
        XCTAssertEqual(point.moveOrigin(by: CGSize(width: -20, height: 40)), CGPoint(x: 60, y: 10))
    }
    
    func testRoundingACGFloat() {
        XCTAssertEqual(CGFloat(123).rounded(decimals: 2), 123)
        XCTAssertEqual(CGFloat(123.456).rounded(decimals: 2), 123.46)
        XCTAssertEqual(CGFloat(123.456789).rounded(decimals: 2), 123.46)
        XCTAssertEqual(CGFloat(123.453).rounded(decimals: 2), 123.45)
        XCTAssertEqual(CGFloat(123.456).rounded(decimals: 2), 123.46)
        XCTAssertEqual(CGFloat(0.01234).rounded(decimals: 2), 0.01)
        XCTAssertEqual(CGFloat(0.00001).rounded(decimals: 2), 0)

        XCTAssertEqual(CGFloat(-123.45).rounded(decimals: 2), -123.45)
        XCTAssertEqual(CGFloat(-1.1).rounded(decimals: 2), -1.1)
        XCTAssertEqual(CGFloat(-1.12345).rounded(decimals: 2), -1.12)
        XCTAssertEqual(CGFloat(-0.091).rounded(decimals: 2), -0.09)
    }
}
