//
//  UNDBaseModel.swift
//  Pods
//
//  Created by Erjian Ni on 17/9/17.
//
//

import UIKit

class UNDBaseModel: NSObject {
    
    // Mark - Log Related
    /// If you need 
    public var shouldShowRelatedLog = false;
    public static let shouldShowClassMethodLog = false;
    
    public static func performConsoleLogForClassMethod<T>(_ logObject : T){
        if shouldShowClassMethodLog {
            Swift.print("\(logObject)")
        }
    }

    public func performConsoleLog<T>(_ logObject : T){
        if shouldShowRelatedLog {
            Swift.print("\(logObject)")
        }
    }
}
