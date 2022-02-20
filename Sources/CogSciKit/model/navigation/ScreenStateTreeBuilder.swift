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
    
    /// Returns a node which loops back to the root node when the given `condition` is met.
    ///
    /// Looping only applies in the forward direction - when navigating backwards, the states
    /// are applied linearly.
    ///
    /// For example, consider this loop:
    /// ```swift
    /// let incrementState = IncrementingState()
    /// let incrementTwice = incrementState.andThen(incrementState)
    /// let root = incrementTwice
    ///    .loop(while: { $0.value < 3 })
    ///    .andThen(SetValue(value: 0))
    ///    .root
    /// ```
    ///
    /// Assume the `IncrementingState` increments a value in the model by 1, and `SetValue` sets the value directly.
    /// In the forward direction, this is equivalent to:
    ///
    /// ```swift
    /// // This is the starting condition of the value, it's not part of our state tree.
    /// // var value = 0
    ///
    /// repeat {
    ///   value += 1
    ///   value += 1
    /// } while(value < 3)
    /// value = 0
    /// ```
    ///
    /// In the reverse direction, we still apply the repeat block, but ignore the while. In the example above, it would be equivalent to:
    /// ```swift
    /// // This is the condition we reached at the end of the forward direction.
    /// // We don't reapply the last node when going backwards, which is why this is commented out.
    /// // value = 0
    ///
    /// value += 1
    /// value += 1
    /// ```
    public func loop(while condition: @escaping (State.Model) -> Bool) -> ScreenStateTreeNode<State> {
        if let previous = self.staticPrev {
            let loopingNode = LoopingScreenStateNode(
                state: self.state,
                startOfLoop: self.root,
                shouldLoop: condition
            )
            previous.attach(to: loopingNode)
            return loopingNode
        }
        
        return LoopingScreenStateNode(
            state: self.state,
            shouldLoop: condition
        )
    }
}
