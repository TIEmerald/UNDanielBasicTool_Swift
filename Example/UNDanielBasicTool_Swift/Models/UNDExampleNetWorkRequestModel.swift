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
    
    public var deviceKey: String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    public var deviceType : Int{
        return 0
    }
    
    public var accessToken : String{
        return UserDefaults.standard.value(forKey: "AccessToken") as! String
    }
    
}

class UNDRegisterRequestModel : UNDExampleNetWorkRequestModel {
    
    public var email: String?
    public var password: String?
    
    // Mark : Read Only Property
    override public var fullAPIURL: String{
        let unrapedEmail = email ?? ""
        let unrapedPassword = password ?? ""
        return "\(super.fullAPIURL)/\(unrapedEmail)/\(unrapedPassword)/\(deviceKey)/\(deviceType)"
    }
    
    static public func generateReqeustModel(withEmail email : String? , _ password : String?) -> UNDRegisterRequestModel {
        let returnRequestModel = UNDRegisterRequestModel(apiMethodName: "/user/register")
        returnRequestModel.email = email
        returnRequestModel.password = password
        return returnRequestModel
    }
}

class UNDLoginRequestModel : UNDExampleNetWorkRequestModel {
    
    public var email: String?
    public var password: String?
    
    // Mark : Read Only Property
    override public var fullAPIURL: String{
        let unrapedEmail = email ?? ""
        let unrapedPassword = password ?? ""
        return "\(super.fullAPIURL)/\(unrapedEmail)/\(unrapedPassword)/\(deviceKey)/\(deviceType)"
    }
    
    static public func generateReqeustModel(withEmail email : String? , _ password : String?) -> UNDLoginRequestModel {
        let returnRequestModel = UNDLoginRequestModel(apiMethodName: "/user/login")
        returnRequestModel.email = email
        returnRequestModel.password = password
        return returnRequestModel
    }
}

class UNDUploadStreemRequestModel :UNDExampleNetWorkRequestModel {
    
    public var canRead : Bool = true
    public var canSeek : Bool = false
    public var canTimeout : Bool = false
    public var canWrite : Bool = false
    public var length : Int = 0
    public var position : Int = 0
    public var readTimeout : Int = 0
    public var writeTimeout : Int = 0
    public var uploadingImage : UIImage?
    
    // Mark : Read Only Property
    override public var appendLogicBlock : UNDNetWorkFormDataUpdatBlock{
        return { (formData) in
            if let unwrapImage = self.uploadingImage {
                if let imageData = UIImagePNGRepresentation(unwrapImage) {
                    formData.appendPart(withFileData: imageData,
                                        name: "file",
                                        fileName: "filename.jpg",
                                        mimeType: "image/png")
                }
            }
        }
    }
    
    override var contentType : String{
        return "image/png"
    }
    
    override public var fullAPIURL: String{
        return "\(super.fullAPIURL)/\(accessToken)"
    }
    
    
    static public func generateReqeustModel(withImage image : UIImage?) -> UNDUploadStreemRequestModel {
        let returnRequestModel = UNDUploadStreemRequestModel(apiMethodName: "/file/uploadstream")
        returnRequestModel.uploadingImage = image
        return returnRequestModel
    }
}
