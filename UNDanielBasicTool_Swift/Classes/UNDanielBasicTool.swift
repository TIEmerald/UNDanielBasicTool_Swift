//
//  UNDanielBasicTool.swift
//  Pods
//
//  Created by 尓健 倪 on 3/6/17.
//
//

import UIKit

public class UNDanielBasicTool: NSObject {
    
    /// This is will contains all Basic Settings we might needed in this pod.
    public static let SharedInstance = UNDanielBasicTool();
    
    /// What will happened if you set this property to yes.
    ///     1. we will show Comment in consoles
    public var isDevelopMode : Bool
    
    override init() {
        isDevelopMode = false // By default we treat this as false...
    }

    
    public static func displayMessageInConsole(_ items: Any..., functionName: String = #function, fileName : String = #file, lineNumber: Int = #line, separator: String = "", terminator: String = "\n") {
        if UNDanielBasicTool.SharedInstance.isDevelopMode {
            // Reference: https://stackoverflow.com/questions/26913799/remove-println-for-release-version-ios-swift
            var idx = items.startIndex
            let endIdx = items.endIndex
            
            let className = (fileName as NSString).lastPathComponent
            Swift.print("<\(className)> \(functionName) [\(lineNumber)] :")
            repeat {
                Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
                idx += 1
            }while idx < endIdx
        }
    }
}
