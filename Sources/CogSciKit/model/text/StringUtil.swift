//
// CogSciKit
//

import Foundation

public struct StringUtil {
    public static func withNoBreaks(str: String) -> String {
        let elements = str.flatMap { c in
            "\(c)\(noBreak)"
        }
        return String(elements)
    }
    
    public static let noBreak = "\u{2060}"

}
