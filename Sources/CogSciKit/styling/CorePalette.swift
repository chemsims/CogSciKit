//
// CogSciKit
//

import SwiftUI

public struct CorePalette {
    private init() { }
    
    public static let orangeAccent = Color("orangeAccent", bundle: .module)
    public static let speechBubble = Color("speechBubble", bundle: .module)
    
    
    
    
    static let inactiveSpeechBubbleButton = Color("inactiveSpeechBubble", bundle: .module)
    
    
    public struct Slider {
        public static let bar = Color("sliderBar", bundle: .module)
        public static let enabledHandle = CorePalette.orangeAccent
        public static let disabledHandle = Color("disabledSliderHandle", bundle: .module)
    }
}
