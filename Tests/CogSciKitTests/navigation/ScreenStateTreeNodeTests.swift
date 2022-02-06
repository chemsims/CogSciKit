//
// CogSciKit
//

import XCTest
import CogSciKit

class ScreenStateTreeNodeTests: XCTestCase {

    func testBuildingLinearStateTree() {
        let s1 = SetValue(value: 1)
        let s2 = SetValue(value: 2)
        let s3 = SetValue(value: 3)
        let s1Node = ScreenStateTreeNode<SetValue>.build(states: [s1, s2, s3])

        XCTAssertNotNil(s1Node)
        XCTAssertEqual(s1Node!.state.value, s1.value)
        XCTAssertNil(s1Node!.prev(model: TesterClass()))

        let s2Node = s1Node?.next(model: TesterClass())
        XCTAssertNotNil(s2Node)
        XCTAssertEqual(s2Node!.state.value, s2.value)
        XCTAssertEqual(s2Node!.prev(model: TesterClass())?.state.value, s1.value)

        let s3Node = s2Node?.next(model: TesterClass())
        XCTAssertNotNil(s3Node)
        XCTAssertEqual(s3Node!.state.value, s3.value)
        XCTAssertEqual(s3Node!.prev(model: TesterClass())?.state.value, s2.value)
        XCTAssertNil(s3Node?.next(model: TesterClass()))
    }
    
    func testAndThenConstructor() {
        let rootState = SetValue(value: 0)
        
        let rootNode = rootState
            .andThen(SetValue(value: 1))
            .root
        
        XCTAssertEqual(rootNode.state.value, 0)
        
        let nextNode = rootNode.next(model: TesterClass())
        XCTAssertNotNil(nextNode)
        XCTAssertEqual(nextNode?.state.value, 1)
        
        let endNode = nextNode?.next(model: .init())
        XCTAssertNil(endNode)
        
        let backToFirstNode = nextNode?.prev(model: .init())
        XCTAssertNotNil(backToFirstNode)
        XCTAssertEqual(backToFirstNode?.state.value, 0)
    }
    
    func testLooping() {
        let incrementState: TesterState = IncrementingState()
        
        let incrementTwice = incrementState.andThen(incrementState)
        
        let root = incrementTwice
            .andThen(
                incrementState
                    .jumpsTo(incrementTwice.root, condition: { $0.value == 3})
            )
            .andThen(SetValue(value: 10))
            .root
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: root)
        
        XCTAssertEqual(tester.value, 1)
        
        navModel.next()
        XCTAssertEqual(tester.value, 2)
        
        navModel.next()
        XCTAssertEqual(tester.value, 3)
        
        // The jump condition is met, so we go back to the first increment
        navModel.next()
        XCTAssertEqual(tester.value, 4)
        
        navModel.next()
        XCTAssertEqual(tester.value, 5)
        
        navModel.next()
        XCTAssertEqual(tester.value, 6)
        
        // The jump condition is no longer met, so we go the next set value state
        navModel.next()
        XCTAssertEqual(tester.value, 10)
        
        navModel.back()
        XCTAssertEqual(tester.value, 11)
        
        navModel.back()
        XCTAssertEqual(tester.value, 12)
        
        navModel.back()
        XCTAssertEqual(tester.value, 13)
        
        // We've reached the start, so there are no more states
        navModel.back()
        XCTAssertEqual(tester.value, 13)
    }
}

private class TesterClass { var value = 0 }
private class TesterState: ScreenState, SubState {
    func delayedStates(model: TesterClass)  -> [DelayedState<SetValue>] {
        []
    }
    func apply(on model: TesterClass) { }

    func unapply(on model: TesterClass) { }

    func reapply(on model: TesterClass) {
        apply(on: model)
    }

    func nextStateAutoDispatchDelay(model: TesterClass) -> Double? {
        nil
    }

    var ignoreOnBack: Bool {
        false
    }

    typealias NestedState = SetValue
    typealias Model = TesterClass
}
private class SetValue: TesterState {
    init(value: Int) {
        self.value = value
    }
    
    let value: Int
    
    override func apply(on model: TesterClass) {
        model.value = value
    }
}

private class IncrementingState: TesterState {
    override func apply(on model: TesterClass) {
        model.value += 1
    }
}
