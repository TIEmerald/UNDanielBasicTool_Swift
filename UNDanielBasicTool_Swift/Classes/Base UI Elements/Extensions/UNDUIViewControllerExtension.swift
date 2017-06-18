//
//  UNDUIViewControllerExtension.swift
//  Pods
//
//  Created by 尓健 倪 on 18/6/17.
//
//

import UIKit

extension UIViewController {
    
    
    /// MARK : - Override Methods
    ////  Override this method if your View Controller is inside a story board
    open class var storyboardName : String {
        return ""
    }
    
    ////  Override this variable with the identifier of your view controller
    open class var viewControllerIdentifier : String {
        return ""
    }
    
    /// MARK : - General Methods
    ////    MARK : Generator
    public static func generateCurrentViewControllerInstanceFromStoryboard() -> UIViewController {
        let currentStoryBoard = UIStoryboard(name: self.storyboardName,
                                             bundle: nil)
        return currentStoryBoard.instantiateViewController(withIdentifier: self.viewControllerIdentifier)
    }
    
    ////    MARK : Navigation Related
    public func addChildViewControllerWithFullSizeWithCurrentView(_ childViewController: UIViewController) {
        UNDanielUtilsTool.performBlockInMainQueu { 
            self.addChildViewController(childViewController)
            if let destView = childViewController.view {
                destView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                destView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.view.frame.size.width,
                                        height: self.view.frame.size.height)
                self.view.addSubview(destView)
            }
            childViewController.didMove(toParentViewController: self)
        }
    }
    
    public func removeSelfFromParentViewController() {
        UNDanielUtilsTool.performBlockInMainQueu { 
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    //// MARK : - Support Methods
}
