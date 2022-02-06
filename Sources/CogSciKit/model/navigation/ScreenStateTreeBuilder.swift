//
//  CogSciKit
//

import Foundation

extension ScreenState {
    
    /// Attaches `nextState` and returns the node which contains it.
    public func andThen(_ nextState: Self) -> ScreenStateTreeNode<Self> {
        let thisNode = ScreenStateTreeNode(state: self)
        return thisNode.andThen(nextState)
    }
    
    /// Wraps this node in another node which jumps to `otherNode` when the provided conditon is met.
    ///
    /// Jumping is a one-way process, and the `otherNode` we node we jump to is not modified. This
    /// means that after we jump, then going back would go to wherever `otherNode` is attached.
    public func jumpsTo(
        _ otherNode: ScreenStateTreeNode<Self>,
        condition: @escaping (Self.Model) -> Bool
    ) -> ScreenStateTreeNode<Self> {
        let thisNode = ScreenStateTreeNode(state: self)
        return thisNode.jumpsTo(otherNode, condition: condition)
    }
}


extension ScreenStateTreeNode {
    
    /// Attaches `nextState` and returns the node which contains it.
    public func andThen(_ nextState: State) -> ScreenStateTreeNode<State>  {
        let nextNode = ScreenStateTreeNode(state: nextState)
        return andThen(nextNode)
    }
    
    /// Attaches `nextNode` at the end of this node. The modified node is returned to enable
    /// method chaining.
    public func andThen(_ nextNode: ScreenStateTreeNode) -> ScreenStateTreeNode<State> {
        self.attach(to: nextNode)
        return nextNode
    }
    
    /// Wraps this node in another node which jumps to `otherNode` when the provided conditon is met.
    ///
    /// Jumping is a one-way process, and the `otherNode` we node we jump to is not modified. This
    /// means that after we jump, then going back would go to wherever `otherNode` is attached.
    public func jumpsTo(
        _ otherNode: ScreenStateTreeNode,
        condition: @escaping (State.Model) -> Bool
    ) -> ScreenStateTreeNode<State> {
        let conditonalNode = ConditionalScreenStateNode(
            state: self.state,
            applyAlternativeNode: condition
        )
        conditonalNode.staticNextAlternative = otherNode
        return conditonalNode
    }
}
