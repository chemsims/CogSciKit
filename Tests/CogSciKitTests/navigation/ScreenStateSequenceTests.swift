//
// CogSciKit
//

import XCTest
import CogSciKit

class ScreenStateSequenceTests: XCTestCase {

    func testAllStatesAreApplied() {
        let states: [TestModelScreenState] = [
            SetValueInApply(key: "a", value: 1),
            SetValueInApply(key: "b", value: 2),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        let model = TestModel()
        sequence.apply(on: model)
        
        XCTAssertEqual(model.values, ["a" : 1, "b": 2])
    }
    
    func testAllStatesAreUnapplied() {
        let states: [TestModelScreenState] = [
            SetValueInUnapply(key: "a", value: 1),
            SetValueInUnapply(key: "b", value: 2),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        let model = TestModel()
        sequence.unapply(on: model)
        
        XCTAssertEqual(model.values, ["a" : 1, "b": 2])
    }
    
    func testAllStatesAreReapplied() {
        let states: [TestModelScreenState] = [
            SetValueInReapply(key: "a", value: 1),
            SetValueInReapply(key: "b", value: 2),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        let model = TestModel()
        sequence.reapply(on: model)
        
        XCTAssertEqual(model.values, ["a" : 1, "b": 2])
    }
    
    func testTheSmallestNextStateAutoDispatchIsReturnedWhenThereAreNonNilValues() {
        let states: [TestModelScreenState] = [
            ReturnNextStateAutoDispatchDelay(delay: 10),
            ReturnNextStateAutoDispatchDelay(delay: nil),
            ReturnNextStateAutoDispatchDelay(delay: 2),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        let model = TestModel()
        XCTAssertEqual(sequence.nextStateAutoDispatchDelay(model: model), 2)
    }
    
    func testNilIsReturnedForNextStateAutoDispatchWhenThereAreOnlyNilValues() {
        let states: [TestModelScreenState] = [
            ReturnNextStateAutoDispatchDelay(delay: nil),
            ReturnNextStateAutoDispatchDelay(delay: nil),
            ReturnNextStateAutoDispatchDelay(delay: nil),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        let model = TestModel()
        XCTAssertEqual(sequence.nextStateAutoDispatchDelay(model: model), nil)
    }
    
    func testStateIsNotSkippedIfNoneOfTheStatesAreSkipped() {
        let states: [TestModelScreenState] = [
            ReturnBackBehaviour(behaviour: .unapply),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        XCTAssertEqual(sequence.backBehaviour, .unapply)
    }
    
    func testStateIsSkippedIfAnyOfTheStatesAreSkipped() {
        let states: [TestModelScreenState] = [
            ReturnBackBehaviour(behaviour: .unapply),
            ReturnBackBehaviour(behaviour: .skip),
            ReturnBackBehaviour(behaviour: .skipAndIgnore)
        ]
        let sequence = ScreenStateSequence(states: states)
        
        XCTAssertEqual(sequence.backBehaviour, .skip)
    }
    
    func testStateIsSkippedAndIgnoredIfAnyOfTheStatesAreSkippedAndIgnoredAndNoneOfThemAreOnlySkipped() {
        let states: [TestModelScreenState] = [
            ReturnBackBehaviour(behaviour: .unapply),
            ReturnBackBehaviour(behaviour: .skipAndIgnore)
        ]
        let sequence = ScreenStateSequence(states: states)
        
        XCTAssertEqual(sequence.backBehaviour, .skipAndIgnore)
    }

    func testStatesWhichAreSkippedAndIgnoredAreNotUnapplied() {
        let states: [TestModelScreenState] = [
            ReturnBackBehaviourAndSetValueInUnapply(key: "a", value: 1, behaviour: .unapply),
            ReturnBackBehaviourAndSetValueInUnapply(key: "b", value: 2, behaviour: .skip),
            ReturnBackBehaviourAndSetValueInUnapply(key: "c", value: 3, behaviour: .skipAndIgnore),
        ]
        let sequence = ScreenStateSequence(states: states)
        
        let model = TestModel()
        sequence.unapply(on: model)
        
        XCTAssertEqual(model.values, ["a" : 1, "b" : 2])
    }
}

private class TestModel {
    var values = [String : Int]()
}

private class TestModelScreenState: ScreenState, SubState {
    
    typealias Model = TestModel
    typealias NestedState = TestModelScreenState
    
    func apply(on model: TestModel) {
    }
    
    func unapply(on model: TestModel) {
    }
    
    func reapply(on model: TestModel) {
    }
    
    
    func delayedStates(model: TestModel) -> [DelayedState<TestModelScreenState>] {
        []
    }
   
    func nextStateAutoDispatchDelay(model: TestModel) -> Double? {
        nil
    }
    
    var backBehaviour: NavigationModelBackBehaviour {
        .unapply
    }
}

private class SetValueInApply: TestModelScreenState {
    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }
    
    let key: String
    let value: Int
    
    override func apply(on model: TestModel) {
        model.values[key] = value
    }
}

private class SetValueInUnapply: TestModelScreenState {
    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }
    
    let key: String
    let value: Int
    
    override func unapply(on model: TestModel) {
        model.values[key] = value
    }
}

private class SetValueInReapply: TestModelScreenState {
    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }
    
    let key: String
    let value: Int
    
    override func reapply(on model: TestModel) {
        model.values[key] = value
    }
}

private class ReturnNextStateAutoDispatchDelay: TestModelScreenState {
    init(delay: Double?) {
        self.delay = delay
    }
    let delay: Double?
    
    override func nextStateAutoDispatchDelay(model: TestModel) -> Double? {
        delay
    }
}

private class ReturnBackBehaviour: TestModelScreenState {
    init(behaviour: NavigationModelBackBehaviour) {
        self.behaviour = behaviour
    }
    
    let behaviour: NavigationModelBackBehaviour
    
    override var backBehaviour: NavigationModelBackBehaviour {
        behaviour
    }
}

private class ReturnBackBehaviourAndSetValueInUnapply: TestModelScreenState {
    init(key: String, value: Int, behaviour: NavigationModelBackBehaviour) {
        self.key = key
        self.value = value
        self.behaviour = behaviour
    }
    
    let key: String
    let value: Int
    let behaviour: NavigationModelBackBehaviour
    
    override func unapply(on model: TestModel) {
        model.values[key] = value
    }
    
    override var backBehaviour: NavigationModelBackBehaviour {
        behaviour
    }
}
