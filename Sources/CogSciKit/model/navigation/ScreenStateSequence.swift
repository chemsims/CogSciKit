//
//  CogSciKit
//

/// A state which composes a sequence of states into a single state.
///
/// - Note:
///   - The `delayedStates` are currently ignored, but this may change later. The smallest
///   - The smallest non-nil `nextStateAutoDispatchDelay` is used for this states delay.
///
///   - `ignoreOnBack` returns true if **any** of the states return true
///
open class ScreenStateSequence<State : ScreenState>: ScreenState {
    
    public init(states: [State]) {
        self.states = states
    }
    
    /// An array of states which this sequnce is composed from.
    public let states: [State]
    
    /// Applies each state in the state array on the model.
    public func apply(on model: State.Model) {
        states.forEach { $0.apply(on: model)}
    }
    
    /// Reapplies each state on the model.
    public func reapply(on model: State.Model) {
        states.forEach { $0.reapply(on: model)}
    }
    
    /// Unapplies all of the nested states whose `backBehaviour` specifies they
    /// should be unapplied.
    public func unapply(on model: State.Model) {
        for state in states {
            if state.backBehaviour.shouldUnapply {
                state.unapply(on: model)
            }
        }
    }
    
    public func delayedStates(model: State.Model) -> [DelayedState<State.NestedState>] {
        []
    }
    
    /// Returns the smallest non-nil delay from the state array.
    public func nextStateAutoDispatchDelay(model: State.Model) -> Double? {
        states
            .compactMap { $0.nextStateAutoDispatchDelay(model: model) }
            .min()
    }
    
    /// Returns an aggregate back behaviour for the array of states.
    ///
    /// If any of the states are skipped, then this returns `.skip`. Note that if some return
    /// `skip` and others return `skipAndIgnore`, then `skip` is still returned, and unapply
    /// is not called for the ignored states.
    public var backBehaviour: NavigationModelBackBehaviour {
        let anyAreSkipped = states.contains { $0.backBehaviour == .skip }
        let anyAreSkippedAndIgnored = states.contains { $0.backBehaviour == .skipAndIgnore }
        if anyAreSkipped {
            return .skip
        } else if anyAreSkippedAndIgnored {
            return .skipAndIgnore
        }
        
        return .unapply
    }
}
