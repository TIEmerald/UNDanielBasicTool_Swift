//
//  UNDExampleNetWorkRequestModel.swift
//  UNDanielBasicTool_Swift
//
//  Created by 尓健 倪 on 4/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import UNDanielBasicTool_Swift

class UNDExampleNetWorkRequestModel: UNDNetWorkAPIRequestModel {
    
    override public var rootURL: String{
        return "http://www.urgentdeal.com.au/api"
    }
    
}

class UNDRegisterRequestModel : UNDExampleNetWorkRequestModel {
    
    public var email: String?
    public var password: String?
    
    public var deviceKey: String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    public var deviceType : Int{
        return 0
    }
    
    // Mark : Read Only Property
    override public var fullAPIURL: String{
        let unrapedEmail = email ?? ""
        let unrapedPassword = password ?? ""
        return "\(super.fullAPIURL)/\(unrapedEmail)/\(unrapedPassword)/\(deviceKey)/\(deviceType)"
    }
    
    static public func generateReqeustModel(withAPIMethod apiMethod: String, _ email : String? , _ password : String?) -> UNDRegisterRequestModel {
        let returnRequestModel = UNDRegisterRequestModel(apiMethodName: apiMethod)
        returnRequestModel.email = email
        returnRequestModel.password = password
        return returnRequestModel
    }
}
