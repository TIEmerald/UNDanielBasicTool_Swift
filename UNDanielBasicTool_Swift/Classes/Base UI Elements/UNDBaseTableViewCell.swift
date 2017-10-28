//
//  TableViewCellExtension.swift
//  Pods
//
//  Created by 尓健 倪 on 15/6/17.
//
//

import UIKit

public class UNDBaseTableViewCell : UITableViewCell {
    
    /// Mark - Constant
    public static let UITableViewCell_BaseModle_Key = "UITableViewCellBaseModleKey"
    
    
    /// Mark: - Override Methods
    /// Override this method with table view cell's nib name
    open class var nibName : String {
        return ""
    }
    
    open class var cellIdentifierName : String {
        return ""
    }
    
    open class var cellHeight : CGFloat{
        return 44.0
    }
    
    // Set Up Related
    open func setupCell(basedOnModelDictionary modelDictionary : Dictionary<String, Any>){
        
    }
    
    open func updateCellUI(){
        
    }
    
    /// Mark: - General Methods
    //// Call this method to register the cell into target table view
    public static func registerSelf(intoTableView tableview: UITableView?) -> Void{
        tableview?.register(UINib.init(nibName: self.nibName, bundle: nil),
                            forCellReuseIdentifier: self.cellIdentifierName)
    }
    
    /// Border Related
    public func setupBorder(withWidth width: CGFloat, andColor borderColor: UIColor, isOutSide: Bool){
        if isOutSide {
            self.frame = self.frame.insetBy(dx: -width, dy: -width)
        }
        
        self.contentView.layer.borderWidth = width
        self.contentView.layer.borderColor = borderColor.cgColor
    }
    
    public func removeBorder(){
        self.contentView.layer.borderWidth = 0
    }
}

