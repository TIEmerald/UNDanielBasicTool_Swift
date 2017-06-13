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
    
    public typealias UNDNetWorkFormDataUpdatBlock = ((AFMultipartFormData) -> Swift.Void)?
    
    public var apiMethodName : String = ""
    
    // MARK: - Read Only Properties
    /// Override this property in your Root Model Class in your Project.
    open var appendLogicBlock : UNDNetWorkFormDataUpdatBlock{
        return nil
    }
    
    open var contentType : String{
        return "application/json; charset=utf-8"
    }
    
    open var parameter : Any?{
        return  nil
    }
    
    open var rootURL : String{
        return ""
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
    
    public static func performPOST(_ requestModel : UNDNetWorkAPIRequestModel, withSuccessHandler successHandler : @escaping (Any?) -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        let manager = AFHTTPSessionManager()
        let requestSerializer = AFHTTPRequestSerializer()
//        requestSerializer.setValue(requestModel.contentType, forHTTPHeaderField: "Accept")
//        requestSerializer.setValue(requestModel.contentType, forHTTPHeaderField: "Content-Type")
        manager.requestSerializer = requestSerializer
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        UNDanielUtilsTool.log("\(requestSerializer.httpRequestHeaders)")
        manager.post(requestModel.fullAPIURL,
                     parameters: requestModel.parameter,
                     constructingBodyWith: { (formData) in
                        if let unwrapedFormDataUpdatBlock = requestModel.appendLogicBlock {
                            unwrapedFormDataUpdatBlock(formData)
                        }
        },
                     progress: nil,
                     success: { (task, responseObject) in
                        logTaskDetail(withTask: task)
                        UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing:requestModel.parameter))\r\t______Response:\(String(describing: responseObject))")
                        successHandler(responseObject)
        }) { (task , error) in
            logTaskDetail(withTask: task)
            UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing:requestModel.parameter))\r\t______Error:\(String(describing: error))", Stuff.logLevel.error)
            if let unwrapErrorHandler = errorHandler {
                unwrapErrorHandler(error)
            }
        }
    }
    
    /// Mark: Support Method
    private static func logTaskDetail(withTask task: URLSessionDataTask?) -> Void{
        if let wrapTask = task {
            UNDanielUtilsTool.log("______HTTP Method:\(String(describing: wrapTask.currentRequest?.httpMethod)) \n______HTTP Headers:\(String(describing: wrapTask.currentRequest?.allHTTPHeaderFields))\n______HTTP Body:\(String(describing: wrapTask.currentRequest?.httpBody))\n______HTTP Body Stream:\(String(describing: wrapTask.currentRequest?.httpBodyStream))")
        }
    }
}
