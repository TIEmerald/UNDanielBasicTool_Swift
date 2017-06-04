//
//  ViewController.swift
//  UNDanielBasicTool_Swift
//
//  Created by niyejunze.j@gmail.com on 06/03/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

import UIKit
import UNDanielBasicTool_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        UNDanielUtilsTool.SharedInstance.isDevelopMode = true
        
        let usingRequst = UNDRegisterRequestModel.generateReqeustModel(withAPIMethod: "/user/register",
                                                                       "newTestEmail6@test.co",
                                                                       "abc")
        UNDNetWorkAPITool.performPOST(usingRequst,
                                      withSuccessHandler: { 
                                        
        }) { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

