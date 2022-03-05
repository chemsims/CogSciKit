//
// CogSciKit
//

import Foundation

public enum NavigationModelBackBehaviour {
    
    /// Calls the `unapply` method of the navigation state, which is the default behaviour.
    case unapply
    
    /// Skips the state, while still calling the `unapply` method.
    case skip
    
    /// Skips the state, without calling the `unapply` method.
    case skipAndIgnore
}

extension NavigationModelBackBehaviour {
    var shouldUnapply: Bool {
        switch self {
        case .unapply, .skip:
            return true
        case .skipAndIgnore:
            return false
        }
    }
    
    var shouldSkip: Bool {
        switch self {
        case .skip, .skipAndIgnore:
            return true
        case .unapply:
            return false
        }
    }
}
