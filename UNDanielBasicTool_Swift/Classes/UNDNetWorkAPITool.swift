//
//  UNDNetWorkAPITool.swift
//  Pods
//
//  Created by 尓健 倪 on 4/6/17.
//
//

import UIKit
import AFNetworking

open class UNDNetWorkAPIRequestModel: NSObject {
    
    public var apiMethodName : String = ""
    
    // MARK: - Read Only Properties
    /// Override this property in your Root Model Class in your Project.
    open var rootURL : String{
        return""
    }
    
    /// Override this property if the fullAPIURL is not simply with structure like "rootURL + apiMethod".
    open var fullAPIURL: String{
        return "\(rootURL)\(apiMethodName)"
    }
    
    
    // MARK: - Inits
    public override convenience init() {
        self.init(apiMethodName: "")
    }
    
    public init(apiMethodName : String) {
        self.apiMethodName = apiMethodName
    }
}

public class UNDNetWorkAPITool: NSObject {
    
    public static func performPOST(_ requestModel : UNDNetWorkAPIRequestModel, withSuccessHandler successHandler : @escaping () -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        let manager = AFHTTPSessionManager()
        //manager.requestSerializer = AFJSONRequestSerializer()
        //manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        manager.post(requestModel.fullAPIURL,
                     parameters: nil,
                     progress: nil,
                     success: { (task, responseObject) in
                        UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\r\t______Response:\(String(describing: responseObject))")
                        successHandler()
        }) { (task , error) in
            if let unwrapErrorHandler = errorHandler {
                UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing: task?.currentRequest))\r\t______Error:\(String(describing: error))", Stuff.logLevel.error)
                unwrapErrorHandler(error)
            }
        }
    }
}
