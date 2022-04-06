//
// CogSciKit
//

import Foundation

public class ScreenStateTreeNode<State: ScreenState> {

    public init(state: State) {
        self.state = state
    }

    public let state: State
    
    var staticNext: ScreenStateTreeNode<State>?
    var staticPrev: ScreenStateTreeNode<State>?
    
    public var root: ScreenStateTreeNode<State> {
        staticPrev?.root ?? self
    }
    
    public func attach(to nextNode: ScreenStateTreeNode) {
        self.staticNext = nextNode
        nextNode.staticPrev = self
    }

    public func next(model: State.Model) -> ScreenStateTreeNode<State>? {
        staticNext
    }

    public func prev(model: State.Model) -> ScreenStateTreeNode<State>? {
        staticPrev
    }
}

/// Repeats the given state as long as `shouldRepeat` returns true, adding
/// new states to the tree hierarchy. Note, this node always applies the state at least once,
/// regardless of the result of `shouldRepeat`.
///
/// Using this node differs to calling the `loop` method, in that new states are
/// kept in the tree hierarchy, so they are called when going back. On the other hand,
/// the `loop` method does not add the repeated nodes to the tree hierarchy,
/// so they are not called when going back.
public class RepeatingScreenStateNode<State : ScreenState>: ScreenStateTreeNode<State> {
    public convenience init(getState: @escaping () -> State, shouldRepeat: @escaping (State.Model) -> Bool) {
        self.init(isStartOfRepeatingChain: true, getState: getState, shouldRepeat: shouldRepeat)
    }
    
    private init(isStartOfRepeatingChain: Bool, getState: @escaping () -> State, shouldRepeat: @escaping (State.Model) -> Bool) {
        self.isStartOfRepeatingChain = isStartOfRepeatingChain
        self.getState = getState
        self.shouldRepeat = shouldRepeat
        super.init(state: getState())
    }
    
    private let isStartOfRepeatingChain: Bool
    private let getState: () -> State
    private let shouldRepeat: (State.Model) -> Bool
    
    override public func next(model: State.Model) -> ScreenStateTreeNode<State>? {
        if shouldRepeat(model) {
            insertAnotherRepeatingNode()
        }
        return super.next(model: model)
    }
    
    override public func prev(model: State.Model) -> ScreenStateTreeNode<State>? {
        guard let staticPrev = staticPrev else {
            return nil
        }
        
        // When we go back, we want to remove the extra nodes from the chain, as
        // they may be re-added when going forward again. Note that the condition
        // may change the next time we go forward, so we may repeat the node
        // a different number of times.
        if !isStartOfRepeatingChain, let staticNext = staticNext {
            staticPrev.attach(to: staticNext)
        }
        
        return staticPrev
    }
    
    private func insertAnotherRepeatingNode() {
        let nextNode = RepeatingScreenStateNode(isStartOfRepeatingChain: false, getState: getState, shouldRepeat: shouldRepeat)
        if let staticNext = staticNext {
            nextNode.attach(to: staticNext)
        }
        self.attach(to: nextNode)
    }
}

class ConditionalScreenStateNode<State: ScreenState>: ScreenStateTreeNode<State> {
    init(state: State, applyAlternativeNode: @escaping (State.Model) -> Bool) {
        self.applyAlternativeNode = applyAlternativeNode
        super.init(state: state)
    }

    private let applyAlternativeNode: (State.Model) -> Bool
    var staticNextAlternative: ScreenStateTreeNode<State>?

    override func next(model: State.Model) -> ScreenStateTreeNode<State>? {
        if applyAlternativeNode(model) {
            return staticNextAlternative
        }
        return staticNext
    }
    
    func conditionallyAttach(to nextNode: ScreenStateTreeNode<State>) {
        self.staticNextAlternative = nextNode
        nextNode.staticPrev = self
    }
}

class LoopingScreenStateNode<State: ScreenState>: ScreenStateTreeNode<State> {
    
    /// Creates a loop which jumps to `startOfLoop` whenever the given condition is met.
    init(
        state: State,
        startOfLoop: ScreenStateTreeNode<State>,
        shouldLoop: @escaping (State.Model) -> Bool
    ) {
        self.startOfLoop = startOfLoop
        self.shouldLoop = shouldLoop
        super.init(state: state)
    }
    
    /// Creates a loop which repeats itself whenever the given condition is met
    init(
        state: State,
        shouldLoop: @escaping (State.Model) -> Bool
    ) {
        self.shouldLoop = shouldLoop
        super.init(state: state)
        self.startOfLoop = self
    }
    
    private var startOfLoop: ScreenStateTreeNode<State>?
    private let shouldLoop: (State.Model) -> Bool
        
    override func next(model: State.Model) -> ScreenStateTreeNode<State>? {
        if shouldLoop(model) {
            return startOfLoop
        } else {
            return super.next(model: model)
        }
    }
}

extension ScreenStateTreeNode {
    public static func build<State: ScreenState>(states: [State]) -> ScreenStateTreeNode<State>? {
        let nodes = states.map { ScreenStateTreeNode<State>(state: $0) }

        (0..<nodes.count).forEach { index in
            let nextIndex = index + 1
            let nextNode = nodes.indices.contains(nextIndex) ? nodes[nextIndex] : nil
            if let nextNode = nextNode {
                nodes[index].attach(to: nextNode)
            }
        }

        return nodes.first
    }
}
