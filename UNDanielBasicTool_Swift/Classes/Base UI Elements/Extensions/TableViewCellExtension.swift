//
//  TableViewCellExtension.swift
//  Pods
//
//  Created by 尓健 倪 on 15/6/17.
//
//

import UIKit


extension UITableViewCell {
    
    /// Mark - Constant
    public static let UITableViewCell_BaseModle_Key = "UITableViewCellBaseModleKey"
    
    
    /// Mark: - Override Methods
    /// Override this method with table view cell's nib name
    open static var nibName : String {
        return ""
    }
    
    open static var cellIdentifierName : String {
        return ""
    }
    
    open static var cellHeight : CGFloat{
        return 44.0
    }
    
    // Set Up Related
    open func setupCell(basedOnModelDictionary modelDictionary : Dictionary){
        
    }
    
    open func updateCellUI(){
        
    }
    
    /// Mark: - General Methods
    //// Call this method to register the cell into target table view
    public static func registerSelf(intoTableView tableview: UITableView?) -> Void{
        tableview.register(type(of: self).nibName,
                           forCellReuseIdentifier: type(of: self).cellIdentifierName)
    }
    
    /// Border Related
    public func setupBorder(withWidth width: CGFloat, andColor borderColor: UIColor, isOutSide: BOOL){
        if isOutSide {
            self.frame = CGRectInset(self.frame, -width, -width)
        }
        
        self.contentView.layer.borderWidth = width
        self.contentView.layer.borderColor = borderColor.CGColor
    }
    
    public func removeBorder(){
        self.contentView.layer.borderWidth = 0
    }
}

