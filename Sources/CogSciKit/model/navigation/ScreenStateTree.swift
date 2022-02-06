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

class ConditionalScreenStateNode<State: ScreenState>: ScreenStateTreeNode<State> {
    public init(state: State, applyAlternativeNode: @escaping (State.Model) -> Bool) {
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
