//
//  UNDTextFieldDropdownList.swift
//  Pods
//
//  Created by 尓健 倪 on 17/6/17.
//
//

import UIKit

public protocol UNDTextFieldDropdownListDelegate : UNDDropDownListDelegate {
    // The Show Drop Down List block is used to show drop down list.... this is in case we need to show dropdown list in another queue (like after post call)
    func textField(_ textField: UITextField, willUpdateTextTo toText:String, andShowDropDownListBlock showDropDownList: ((Bool) -> Void)?)
    
    // This method will be called after the target TextField's - textFieldDidEndEditing be called.
    func targetTextFieldDidEndEditting(_ textfield: UITextField)
    
    // This method will handle logic for the associated text field return button
    func targetTextFieldWillReturn(_ textfield: UITextField)
}

extension UNDTextFieldDropdownListDelegate{
    // This is trying to make some method optional
    func textField(_ textField: UITextField, willUpdateTextTo toText:String, andShowDropDownListBlock showDropDownList: ((Bool) -> Void)?){
        
    }
    
    func targetTextFieldDidEndEditting(_ textfield: UITextField){
        
    }
    
    func targetTextFieldWillReturn(_ textfield: UITextField){
        
    }
}

public class UNDTextFieldDropdownList: UNDDropDownListTableViewController, UITextFieldDelegate {

    // MARK : - ENUM
    //      Will used to define the senetiy how open should we show up drop down list will user is typing
    public enum TypingSensity: Int {
        case none
        case high
        case low
        case dum
        
        public func relatedTimeInterval() -> TimeInterval{
            switch self {
            case .none:
                return TimeInterval(exactly: 0)!
            case .high:
                return TimeInterval(exactly: 0.1)!
            case .low:
                return TimeInterval(exactly: 0.3)!
            case .dum:
                return TimeInterval(exactly: 0.5)!
            }
        }
    }
    
    // MARK : - Interfaces
    weak var delegatForTextField : UNDTextFieldDropdownListDelegate?
    override public var delegate: UNDDropDownListDelegate?{
        didSet{
            delegatForTextField = delegate as? UNDTextFieldDropdownListDelegate
        }
    }
    
    //  This property will tell UNDTextFieldDDL our Dropdown List should be how many wider than the view you assoicated
    public var extendWidth : CGFloat = 0.0
    
    //  This property will tell UNDTextFieldDDL how mayn second you want to wait after you stop typing to call the function to loading drop down list.
    //   It is used to tell is user keep typing or not.
    public var typingSensity : TypingSensity = .none
    
    //  This porperty is in case you don't what to show up drop down list directly under text field.
    public var associatedView : UIView? {
        get{
            if let unwrapedView = _associatedView{
                return unwrapedView
            }
            return currentAssociateTextField
        }
        
        set(newValue){
            _associatedView = newValue
        }
    }
    
    /// Read Only Property
    //  This will tell you currently, which text field the drop down list is linked with.... Because, you could assign more than one textfield associated with this DropdownList.
    public var currentAssociateTextField : UITextField?{
        return _currentAssociateTextField
    }
    
    /// Privet Property
    private var _associatedView : UIView?
    private var _baseDropdownListWidth : CGFloat = 0
    private var _currentAssociateTextField : UITextField?
    
    /// MARK : - Public Methods
    //  This method will associate Text Field with current Dropdown List.....
    public func associateTextFieldWithSelf(_ textfield:UITextField){
        textfield.delegate = self
    }
    
    /// MARK : - Private Methods
    ///  MARK : - Override Methods
    override public var dropdownListOriginPoint : CGPoint {
        if let unwrapedView = associatedView {
            if let convertedRect = unwrapedView.superview?.convert(unwrapedView.frame,
                                                                   to: self.view.superview){
                return CGPoint(x: convertedRect.origin.x,
                               y: convertedRect.origin.y + convertedRect.size.height)
            }
        }
        return CGPoint(x: 0,
                       y: 0)
    }
    
    override public var dropdownListWidth : CGFloat{
        if let unwrapedView = associatedView {
            return unwrapedView.frame.size.width + extendWidth
        }
        return extendWidth
    }
    
    override public func resignFirstResponder() -> Bool {
        _currentAssociateTextField?.resignFirstResponder()
        _currentAssociateTextField = nil
        return super.resignFirstResponder()
    }
    
    /// MARK : - Delegate
    ///  MARK : - TextField Delegate
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        _currentAssociateTextField = textField
        
        var resultString = ""
        if let nsString = textField.text as NSString? {
            resultString = nsString.replacingCharacters(in: range, with: string)
        }
        
        let performTFTextUpdateArgDictionary = [PerformTFTextUpdateArgDictionaryKey_TextField : textField,
                                                PerformTFTextUpdateArgDictionaryKey_StringAfterChange :resultString] as [String : Any]
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.perform(#selector(performTextfiedlTextUpdateWithDictionary(_:)),
                     with: performTFTextUpdateArgDictionary,
                     afterDelay: self.typingSensity.relatedTimeInterval())
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideDropdownList()
        _currentAssociateTextField = textField
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if _currentAssociateTextField == textField{
            if let unwrapDelegate = self.delegate as! UNDTextFieldDropdownListDelegate?{
                if unwrapDelegate.responds(to: Selector(("targetTextFieldDidEndEditting:"))) {
                    unwrapDelegate.targetTextFieldDidEndEditting(textField)
                }
            }
            _ = self.resignFirstResponder()
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if _currentAssociateTextField == textField{
            if let unwrapDelegate = self.delegate as! UNDTextFieldDropdownListDelegate?{
                if unwrapDelegate.responds(to: Selector(("targetTextFieldWillReturn:"))) {
                    unwrapDelegate.targetTextFieldWillReturn(textField)
                }
            }
        }
        return true
    }
    
    ///  MARK : Support Methods
    let PerformTFTextUpdateArgDictionaryKey_TextField = "PTFTUADK_TextField"
    let PerformTFTextUpdateArgDictionaryKey_StringAfterChange = "PTFTUADK_StringAfterChange"
    
    @objc private func performTextfiedlTextUpdateWithDictionary(_ arguments : Dictionary<String, Any>) -> Void {
        let textField = arguments[PerformTFTextUpdateArgDictionaryKey_TextField] as! UITextField
        let stringAfterChange = arguments[PerformTFTextUpdateArgDictionaryKey_StringAfterChange] as! String
        if let unwrapDelegate = self.delegate as! UNDTextFieldDropdownListDelegate?{
            if unwrapDelegate.responds(to: Selector(("textField:willUpdateTextTo:andShowDropDownListBlock:"))) {
                unwrapDelegate.textField(textField,
                                         willUpdateTextTo: stringAfterChange,
                                         andShowDropDownListBlock: { (shouldShow) in
                                            self.hideDropdownList()
                                            if shouldShow {
                                                self.reloadData()
                                                self.showUp()
                                            }
                })
            }
        }
    }

}
