//
//  UNDBaseTextField.swift
//  Pods
//
//  Created by 尓健 倪 on 15/6/17.
//
//

import UIKit

open class UNDBaseTextField: UITextField {
    
    /// Pading Related....
    // Set this value if you want to add padding to the textfield displayed text
    public var textPadding : UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    // Set this value if you want to add padding to the textfield edit text
    public var editPadding : UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    
    /// If you link any text field to this property this text field will becomeFirstResponder after this resignFirstResponder
    @IBOutlet var nextTextField : UITextField?

    /// Mark : - UITextField
    override open func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + self.textPadding.left,
                      y: bounds.origin.y + self.textPadding.top,
                      width: bounds.size.width - self.textPadding.right - self.textPadding.left,
                      height: bounds.size.height - self.textPadding.top - self.textPadding.bottom)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + self.editPadding.left,
                      y: bounds.origin.y + self.editPadding.top,
                      width: bounds.size.width - self.editPadding.right - self.editPadding.left,
                      height: bounds.size.height - self.editPadding.top - self.editPadding.bottom)
    }
    
    override open func resignFirstResponder() -> Bool {
        if let wrapedTextField = nextTextField {
            wrapedTextField.becomeFirstResponder()
            return true
        }
        return super.resignFirstResponder()
    }
    
    /// Mark: Support Methods
    
}
