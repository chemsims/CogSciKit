//
//  CogSciKit
//

/// A state which composes a sequence of states into a single state.
///
/// - Note:
///   - The `delayedStates` returns all the delayed states of the provided sequence,
///   reordered to maintain the correct timing.
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
    
    /// Returns the delayed states from the sequence, re-ordered to maintain correct timing.
    ///
    /// For example, say we have state A with the delayed state A1 after 1 second, and A2 1 second after that.
    /// And say we have state B with delayed state B1 after 1.5 seconds.
    ///
    /// The overall states and their delays should be A1 (1 second), B1 (0.5 seconds), A2 (0.5 seconds).
    public func delayedStates(model: State.Model) -> [DelayedState<State.NestedState>] {
        flattenDelayedStates(states.map { $0.delayedStates(model: model) })
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

extension ScreenStateSequence {
    private func flattenDelayedStates(_ states: [[DelayedState<State.NestedState>]]) -> [DelayedState<State.NestedState>] {
        let statesWithAbsoluteDelay = states.flatMap(mapRelativeDelaysToAbsoluteDelays)
        
        let orderedStates = statesWithAbsoluteDelay.sorted {
            $0.delay < $1.delay
        }
        
        return mapAbsoluteDelaysToRelativeDelays(orderedStates)
    }
    
    // Converts each state (except the first one) to use an absolute delay, instead of being
    // relative to the previous state.
    private func mapRelativeDelaysToAbsoluteDelays(_ states: [DelayedState<State.NestedState>]) -> [DelayedState<State.NestedState>] {
        var result = [DelayedState<State.NestedState>]()
        var timeAccumulator = 0.0
        
        for delayedState in states {
            let newDelay = delayedState.delay + timeAccumulator
            let newState = delayedState.withDelay(newDelay)
            
            result.append(newState)
            timeAccumulator += delayedState.delay
        }
        
        return result
    }
    
    // Converts each state to use a delay relative to the previous state, instead of
    // being an absolute delay.
    private func mapAbsoluteDelaysToRelativeDelays(_ states: [DelayedState<State.NestedState>]) -> [DelayedState<State.NestedState>] {
        var result = [DelayedState<State.NestedState>]()
        var previousTime = 0.0
        
        for delayedState in states {
            let newDelay = delayedState.delay - previousTime
            let newState = delayedState.withDelay(newDelay)
            
            result.append(newState)
            previousTime = delayedState.delay
        }
        
        return result
    }
}

private extension DelayedState {
    func withDelay(_ newValue: Double) -> DelayedState<State> {
        DelayedState(state: state, delay: newValue)
    }
}
