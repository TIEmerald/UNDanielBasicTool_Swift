//
//  UNDRegexTool.swift
//  Pods
//
//  Created by 尓健 倪 on 23/6/17.
//
//

import UIKit

public class UNDRegexTool: NSObject {
    
    /// MARK : - Constants
    //// MARK : Pattern
    private static let UNDRegexTool_Pattern_Alphabets = "[A-z]*"
    private static let UNDRegexTool_Pattern_Numbers = "[0-9]*"
    private static let UNDRegexTool_Pattern_Email = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
    private static let UNDRegexTool_Pattern_Name = "[a-z]+$"
    private static let UNDRegexTool_Pattern_IPv4Address = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    
    public enum type : Int {
        case alphabets = 1
        case number = 2
        case email = 3
        case name = 4
        case ipadressv4 = 5
        
        public func usingPattern() -> String {
            switch self {
            case .alphabets:
                return UNDRegexTool.UNDRegexTool_Pattern_Alphabets
            case .number:
                return UNDRegexTool.UNDRegexTool_Pattern_Numbers
            case .email:
                return UNDRegexTool.UNDRegexTool_Pattern_Email
            case .name:
                return UNDRegexTool.UNDRegexTool_Pattern_Name
            case .ipadressv4:
                return UNDRegexTool.UNDRegexTool_Pattern_IPv4Address
            }
        }
    }
    
    
    /// MARK : - General Methods
    //// MARK : Normal String Validation
    public static func validateString(_ string: String, withType type : type) -> Bool{
        return self.validateString(string,
                                   withPattern: type.usingPattern(),
                                   andOptions: .caseInsensitive)
    }
    
    /// MARK : - Support Methods
    public static func validateString(_ string: String, withPattern pattern:String, andOptions options:NSRegularExpression.Options) -> Bool{
        var returnValue : Bool = false
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern,
                                                            options: options)
            let textRange = NSRange(location: 0, length: string.characters.count)
            let matchedRange = regularExpression.rangeOfFirstMatch(in: string,
                                                                   options: .reportProgress,
                                                                   range: textRange)
            returnValue = matchedRange.location != NSNotFound && matchedRange.length > 0
        } catch {
            assertionFailure("Failed to generate regular expression")
        }
        return returnValue
    }

}
