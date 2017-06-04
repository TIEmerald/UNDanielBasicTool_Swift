//
//  UNDanielBasicTool.swift
//  Pods
//
//  Created by 尓健 倪 on 3/6/17.
//
//

import UIKit

public class UNDanielUtilsTool: NSObject {
    
    /// This is will contains all Basic Settings we might needed in this pod.
    public static let SharedInstance = UNDanielUtilsTool();
    
    /// What will happened if you set this property to yes.
    ///     1. we will show Comment in consoles
    public var isDevelopMode : Bool
    
    override init() {
        isDevelopMode = false // By default we treat this as false...
    }

    
    public static func log<T>(_ object: T, _ level: Stuff.logLevel = .debug, functionName: String = #function, fileName : String = #file, lineNumber: Int = #line) {
        if UNDanielUtilsTool.SharedInstance.isDevelopMode {
            Stuff.print(object, level, filename: fileName, line: lineNumber, funcname: functionName)
        }
    }
}

// Reference: https://github.com/evermeer/Stuff#print
public class Stuff {
    
    public enum logLevel: Int {
        case info = 1
        case debug = 2
        case warn = 3
        case error = 4
        case fatal = 5
        case none = 6
        
        public func description() -> String {
            switch self {
            case .info:
                return "❓"
            case .debug:
                return "✳️"
            case .warn:
                return "⚠️"
            case .error:
                return "🚫"
            case .fatal:
                return "🆘"
            case .none:
                return ""
            }
        }
    }
    
    public static var minimumLogLevel: logLevel = .info
    
    public static func print<T>(_ object: T, _ level: logLevel = .debug, filename: String = #file, line: Int = #line, funcname: String = #function) {
        if level.rawValue >= Stuff.minimumLogLevel.rawValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
            let process = ProcessInfo.processInfo
            let threadId = "?"
            let file = URL(string: filename)?.lastPathComponent ?? ""
            Swift.print("\n\(level.description()) .\(level) *** \(dateFormatter.string(from: Foundation.Date())) *** \(process.processName) [\(process.processIdentifier):\(threadId)] <\(file)> \(funcname) [Line \(line)] : \r\t\(object)")
        }
    }
}
