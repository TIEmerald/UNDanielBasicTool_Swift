//
//  ViewController.swift
//  UNDanielBasicTool_Swift
//
//  Created by niyejunze.j@gmail.com on 06/03/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

import UIKit
import UNDanielBasicTool_Swift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        UNDanielUtilsTool.SharedInstance.isDevelopMode = true
        
        let usingRequst = UNDRegisterRequestModel.generateReqeustModel(withEmail:"newTestEmail6@test.co",
                                                                       "abc")
        UNDNetWorkAPITool.performHTTPPOST(usingRequst,
                                          withSuccessHandler: { (returnObject) in
                                            
        }) { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Mark: IBAction
    @IBAction func loginButtonTaped(_ sender: UIButton) {
        let usingRequst = UNDLoginRequestModel.generateReqeustModel(withEmail:"newTestEmail6@test.co",
                                                                       "abc")
        UNDNetWorkAPITool.performHTTPPOST(usingRequst,
                                          withSuccessHandler: { (returnObject) in
                                            let returnDictionary = returnObject as! Dictionary<String, Any>
                                            if let accessToke = returnDictionary["AccessToken"]{
                                                let defaults = UserDefaults.standard
                                                defaults.set(accessToke, forKey: "AccessToken")
                                            }
        }) { (error) in
            
        }
    }
    
    @IBAction func uploadImageFromLibraryToServer(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,
                animated: true,
                completion: nil);
    }
    
    /// Mark: Delegates
    /// Mark: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let seletedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let usingRequest = UNDUploadStreemRequestModel.generateReqeustModel(withImage: seletedImage)
            usingRequest.performPOST(withSuccessHandler: { (result) in
                
            }, andErrorHandler: { (error) in
                
            })
        }
    }
}

