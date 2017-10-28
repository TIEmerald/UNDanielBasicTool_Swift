//
//  UNDDDLSampleTableViewCell.swift
//  Pods
//
//  Created by 尓健 倪 on 18/6/17.
//
//

import UIKit

public class UNDDDLSampleTableViewCell: UNDBaseTableViewCell {
    
    
    /// MARK : - IBOutlets
    @IBOutlet var nameLabel: UILabel?
    
    /// Mark: - Override Methods
    ///  MARK : UND TableViewCell Extension
    override public class var nibName : String {
        return "UNDDDLSampleTableViewCell"
    }
    
    override public class var cellIdentifierName : String {
        return "UNDDDLSampleTableViewCell"
    }
    
    override public class var cellHeight : CGFloat{
        return 44.0
    }
    
    // Set Up Related
    override public func setupCell(basedOnModelDictionary modelDictionary : Dictionary<String, Any>){
        let labelString = modelDictionary[UNDDDLSampleTableViewCell.UITableViewCell_BaseModle_Key] as! String
        self.textLabel?.text = labelString
    }
    
}
