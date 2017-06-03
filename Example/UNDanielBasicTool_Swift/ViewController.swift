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
        UNDanielBasicTool.SharedInstance.isDevelopMode = true
        UNDanielBasicTool.log("Some thing")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

