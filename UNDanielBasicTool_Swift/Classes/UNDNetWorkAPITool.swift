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
    public enum UNDRquestModelType: Int {
        case typeOne = 1 /// Currently, I have no idea what exactly the difference is, but there some difference of the logic how to form request.
        case typeTwo = 2
    }
    
    public var apiMethodName : String = ""
    
    /// MARK: - Override Part
    /// MARK: - Read Only Properties
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
    
    open var type : UNDRquestModelType{
        return UNDRquestModelType.typeOne
    }
    
    /// MARK: - Methods To Override
    open func updateBeforePost(withMutableRequest request: NSMutableURLRequest) {
        
    }
    
    // MARK: - Inits
    public override convenience init() {
        self.init(apiMethodName: "")
    }
    
    public init(apiMethodName : String) {
        self.apiMethodName = apiMethodName
    }
    
    // MARK: - General Methods
    public func performPOST(withSuccessHandler successHandler : @escaping (Any?) -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        switch self.type {
        case .typeOne:
            self.performHTTPPOST(withSuccessHandler: successHandler,
                                 andErrorHandler: errorHandler)
        case .typeTwo:
            self.performURLPOST(withSuccessHandler: successHandler,
                                andErrorHandler: errorHandler)
        }
    }

    //  MARK: Support Methods
    public func performHTTPPOST(withSuccessHandler successHandler : @escaping (Any?) -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        UNDNetWorkAPITool.performHTTPPOST(self, withSuccessHandler: successHandler, andErrorHandler: errorHandler);
    }
    
    public func performURLPOST(withSuccessHandler successHandler : @escaping (Any?) -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        UNDNetWorkAPITool.performURLPOST(self, withSuccessHandler: successHandler, andErrorHandler: errorHandler);
    }
}

public class UNDNetWorkAPITool: NSObject {
    
    public static func performHTTPPOST(_ requestModel : UNDNetWorkAPIRequestModel, withSuccessHandler successHandler : @escaping (Any?) -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        let manager = AFHTTPSessionManager()
        let requestSerializer = AFHTTPRequestSerializer()
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
                        logRequestDetail(withRequest: task.currentRequest)
                        UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing:requestModel.parameter))\r\t______Response:\(String(describing: responseObject))")
                        successHandler(responseObject)
        }) { (task , error) in
            logRequestDetail(withRequest: task?.currentRequest)
            UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing:requestModel.parameter))\r\t______Error:\(String(describing: error))", Stuff.logLevel.error)
            if let unwrapErrorHandler = errorHandler {
                unwrapErrorHandler(error)
            }
        }
    }
    
    public static func performURLPOST(_ requestModel : UNDNetWorkAPIRequestModel, withSuccessHandler successHandler : @escaping (Any?) -> Void, andErrorHandler errorHandler : ((_ error : Error) -> Void)?){
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let mutableRequest = AFHTTPRequestSerializer().request(withMethod: "POST",
                                                               urlString: requestModel.fullAPIURL,
                                                               parameters: requestModel.parameter,
                                                               error: nil)
        requestModel.updateBeforePost(withMutableRequest: mutableRequest);
        logRequestDetail(withRequest: mutableRequest as URLRequest)
        
        let task = manager.dataTask(with: mutableRequest as URLRequest) { (response, responseObject, error) in
            if let convertedError = error {
                UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing:requestModel.parameter))\r\t______Error:\(String(describing: convertedError))", Stuff.logLevel.error)
                if let unwrapErrorHandler = errorHandler {
                    unwrapErrorHandler(convertedError)
                }
                return
            }
            UNDanielUtilsTool.log("______Request URL:\(requestModel.fullAPIURL)\r\t______Request:\(String(describing:requestModel.parameter))\r\t______Response:\(String(describing: responseObject))")
            successHandler(responseObject)
        }
        
        task.resume()
    }
    
    
    /// Mark: Support Method
    private static func logRequestDetail(withRequest request: URLRequest?) -> Void{
        if let wrapRequest = request {
            UNDanielUtilsTool.log("______HTTP Method:\(String(describing: wrapRequest.httpMethod)) \n______HTTP Headers:\(String(describing: wrapRequest.allHTTPHeaderFields))\n______HTTP Body:\(String(describing: wrapRequest.httpBody))\n______HTTP Body Stream:\(String(describing: wrapRequest.httpBodyStream))")
        }
    }
}
