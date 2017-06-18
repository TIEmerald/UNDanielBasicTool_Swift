//
//  UNDDDLSampleTableViewCell.swift
//  Pods
//
//  Created by 尓健 倪 on 18/6/17.
//
//

import UIKit

class UNDDDLSampleTableViewCell: UITableViewCell {
    
    
    /// MARK : - IBOutlets
    @IBOutlet var nameLabel: UILabel!
    
    /// Mark: - Override Methods
    ///  MARK : UND TableViewCell Extension
    override class var nibName : String {
        return "UNDDDLSampleTableViewCell"
    }
    
    override class var cellIdentifierName : String {
        return "UNDDDLSampleTableViewCell"
    }
    
    override class var cellHeight : CGFloat{
        return 44.0
    }
    
    // Set Up Related
    override func setupCell(basedOnModelDictionary modelDictionary : Dictionary<String, Any>){
        let labelString = modelDictionary[UITableViewCell.UITableViewCell_BaseModle_Key] as! String
        nameLabel.text = labelString
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
