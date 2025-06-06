//
// CogSciKit
//

import Foundation

public class NavigationModel<State: ScreenState> {

    public var nextScreen: (() -> Void)?
    public var prevScreen: (() -> Void)?

    // TODO - make this weak
    public let model: State.Model

    private var currentNode: ScreenStateTreeNode<State>

    private var nextTimer: Timer?
    private var subTimer: Timer?

    public convenience init(model: State.Model, states: [State]) {
        let rootNode = ScreenStateTreeNode<State>.build(states: states)
        assert(rootNode != nil)
        self.init(model: model, rootNode: rootNode!)
    }

    public init(model: State.Model, rootNode: ScreenStateTreeNode<State>) {
        self.currentNode = rootNode
        self.model = model
        currentNode.state.apply(on: self.model)
    }

    @objc public func next() {
        if let nextNode = currentNode.next(model: model) {
            let state = nextNode.state
            state.apply(on: model)
            currentNode = nextNode
            scheduleSubState(indexToRun: 0)
            scheduleNextState(for: state)
        } else if let nextScreen = nextScreen {
            nextScreen()
        }
    }

    public func back() {
        if let previousNode = currentNode.prev(model: model) {
            let currentState = currentNode.state
            let previousState = previousNode.state
            
            if currentState.backBehaviour.shouldUnapply {
                currentState.unapply(on: model)
            }
            
            currentNode = previousNode
            
            if previousState.backBehaviour.shouldSkip {
                back()
            } else {
                previousState.reapply(on: model)
                scheduleSubState(indexToRun: 0)
                scheduleNextState(for: previousState)
            }
        } else if let prevScreen = prevScreen {
            prevScreen()
        }
    }

    public var hasNext: Bool {
        currentNode.next(model: model) != nil
    }
    
    public var hasPrevious: Bool {
        currentNode.prev(model: model) != nil
    }

    private func scheduleSubState(indexToRun: Int) {
        if let timer = subTimer {
            timer.invalidate()
            subTimer = nil
        }
        let state = currentNode.state
        let delayedStates = state.delayedStates(model: model)
        guard delayedStates.count > indexToRun else {
            return
        }

        let next = delayedStates[indexToRun]
        subTimer = Timer.scheduledTimer(
            timeInterval: next.delay,
            target: self,
            selector: #selector(runForIndex),
            userInfo: indexToRun,
            repeats: false
        )
    }

    @objc private func runForIndex(timer: Timer) {
        let state = currentNode.state
        let delayedStates = state.delayedStates(model: model)
        guard let index = timer.userInfo as? Int, delayedStates.count > index else {
            return
        }
        delayedStates[index].state.apply(on: model)
        scheduleSubState(indexToRun: index + 1)
    }

    private func scheduleNextState(for state: State) {
        if let timer = nextTimer {
            timer.invalidate()
            nextTimer = nil
        }
        if let delay = state.nextStateAutoDispatchDelay(model: model) {
            nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(next), userInfo: nil, repeats: false)
        }
    }
}
