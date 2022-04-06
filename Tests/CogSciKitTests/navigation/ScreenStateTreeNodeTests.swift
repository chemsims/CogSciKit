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
    
    func testJumpingToAnotherNode() {
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
    
    func testLoopingANodeWithAParentOnce() {
        let incrementState: TesterState = IncrementingState()
        let incrementTwice = incrementState.andThen(incrementState)
        let root = incrementTwice
            .loop(while: { $0.value < 3 })
            .andThen(SetValue(value: 0))
            .root
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: root)
        
        XCTAssertEqual(tester.value, 1)
        
        navModel.next()
        XCTAssertEqual(tester.value, 2)
        
        navModel.next()
        XCTAssertEqual(tester.value, 3)
        
        navModel.next()
        XCTAssertEqual(tester.value, 4)
        
        navModel.next()
        XCTAssertEqual(tester.value, 0)
        
        navModel.back()
        XCTAssertEqual(tester.value, 1)
        
        navModel.back()
        XCTAssertEqual(tester.value, 2)
        
        XCTAssertFalse(navModel.hasPrevious)
    }
    
    func testLoopingANodeWithAParentTwice() {
        let incrementState: TesterState = IncrementingState()
        let incrementTwice = incrementState.andThen(incrementState)
        let root = incrementTwice
            .loop(while: { $0.value < 5 })
            .andThen(SetValue(value: 0))
            .root
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: root)
        
        XCTAssertEqual(tester.value, 1)
        
        navModel.next()
        XCTAssertEqual(tester.value, 2)
        
        navModel.next()
        XCTAssertEqual(tester.value, 3)
        
        navModel.next()
        XCTAssertEqual(tester.value, 4)
        
        navModel.next()
        XCTAssertEqual(tester.value, 5)
        
        navModel.next()
        XCTAssertEqual(tester.value, 6)
        
        navModel.next()
        XCTAssertEqual(tester.value, 0)
        
        navModel.back()
        XCTAssertEqual(tester.value, 1)
        
        navModel.back()
        XCTAssertEqual(tester.value, 2)
        
        XCTAssertFalse(navModel.hasPrevious)
    }
    
    func testLoopingANodeWithNoParentTwice() {
        let incrementState: TesterState = IncrementingState()
        
        let root = ScreenStateTreeNode(state: incrementState)
            .loop(while: { $0.value < 3 })
            .andThen(SetValue(value: 0))
            .root
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: root)
        
        XCTAssertEqual(tester.value, 1)
        
        navModel.next()
        XCTAssertEqual(tester.value, 2)
        
        XCTAssert(navModel.hasNext)
        
        navModel.next()
        XCTAssertEqual(tester.value, 3)
        
        navModel.next()
        XCTAssertEqual(tester.value, 0)
                
        navModel.back()
        XCTAssertEqual(tester.value, 1)
        
        XCTAssertFalse(navModel.hasPrevious)
    }
    
    func testRepeatingNodeRepeatsTheProvidedState() {
        let node = RepeatingScreenStateNode(
            getState: { IncrementingState(shouldUnapply: true, shouldReapply: false) },
            shouldRepeat: { $0.value < 3 }
        )
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: node)
        
        XCTAssertEqual(tester.value, 1)
        
        navModel.next()
        XCTAssertEqual(tester.value, 2)
        
        navModel.next()
        XCTAssertEqual(tester.value, 3)
        XCTAssertFalse(navModel.hasNext)
        
        navModel.back()
        XCTAssertEqual(tester.value, 2)
        
        navModel.back()
        XCTAssertEqual(tester.value, 1)
        XCTAssertFalse(navModel.hasPrevious)
    }
    
    func testRepeatingNodeBetweenTwoRegularNodes() {
        let repeatingState: ScreenStateTreeNode<TesterState> = RepeatingScreenStateNode(
            getState: { IncrementingState(shouldUnapply: true, shouldReapply: false) },
            shouldRepeat: { $0.value < 3 }
        )
        let firstState: ScreenStateTreeNode<TesterState> = ScreenStateTreeNode(state: SetValue(value: 1))
        let lastState: ScreenStateTreeNode<TesterState> = ScreenStateTreeNode(state: SetValue(value: 10))
        
        let rootNode = firstState.andThen(repeatingState).andThen(lastState).root
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: rootNode)
        
        XCTAssertEqual(tester.value, 1)
        
        navModel.next()
        XCTAssertEqual(tester.value, 2)
        
        navModel.next()
        XCTAssertEqual(tester.value, 3)
        
        navModel.next()
        XCTAssertEqual(tester.value, 10)
        XCTAssertFalse(navModel.hasNext)
        
        // We reapply the final IncrementState, which does nothing
        navModel.back()
        XCTAssertEqual(tester.value, 10)
        
        // Now the final IncrementState unapplies, reducing the value by 1
        navModel.back()
        XCTAssertEqual(tester.value, 9)
        
        // The first SetValue state reapplies, which sets the value to 1
        navModel.back()
        XCTAssertEqual(tester.value, 1)
        XCTAssertFalse(navModel.hasPrevious)
    }
    
    func testRepeatingNodesDoesntAddDuplicateStatesWhenGoingBackAndThenForwards() {
        let repeatingNode: ScreenStateTreeNode<TesterState> = RepeatingScreenStateNode(
            getState: { IncrementingState(shouldUnapply: true, shouldReapply: false) },
            shouldRepeat: { $0.value < 3 }
        )
        let endState = IncrementingState(shouldUnapply: true, shouldReapply: false)
        
        let rootNode = repeatingNode.andThen(endState).root
        
        let tester = TesterClass()
        let navModel = NavigationModel(model: tester, rootNode: rootNode)
        
        XCTAssertEqual(tester.value, 1)
        
        // Go next until the last state
        navModel.next()
        navModel.next()
        navModel.next()
        XCTAssertEqual(tester.value, 4)
        XCTAssertFalse(navModel.hasNext)
        
        // Go back to the start again
        navModel.back()
        navModel.back()
        navModel.back()
        XCTAssertEqual(tester.value, 1)
        XCTAssertFalse(navModel.hasPrevious)
        
        // Now, go forward again
        navModel.next()
        navModel.next()
        navModel.next()
        XCTAssertEqual(tester.value, 4)
        XCTAssertFalse(navModel.hasNext)
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

    var backBehaviour: NavigationModelBackBehaviour {
        .unapply
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
    
    init(shouldUnapply: Bool = false, shouldReapply: Bool = true) {
        self.shouldUnapply = shouldUnapply
        self.shouldReapply = shouldReapply
    }
    
    let shouldUnapply: Bool
    let shouldReapply: Bool
    
    override func apply(on model: TesterClass) {
        model.value += 1
    }
    
    override func reapply(on model: TesterClass) {
        if shouldReapply {
            apply(on: model)
        }
    }
    
    override func unapply(on model: TesterClass) {
        if shouldUnapply {
            model.value -= 1
        }
    }
}
