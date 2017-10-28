//
//  UNDDropDownListTableViewController.swift
//  Pods
//
//  Created by 尓健 倪 on 17/6/17.
//
//

import UIKit

public protocol UNDDropDownListDelegate : NSObjectProtocol {
    
    func dropdownList(_ dropdownList: UNDDropDownListTableViewController, didSelectCellAtIndexPath indexPath: IndexPath) -> Void
    
    func dropdownList(_ dropdownList: UNDDropDownListTableViewController, dataAtIndexPath indexPath: IndexPath) -> Any
    
    func numberOfCellsInDropdownList(_ dropdownList: UNDDropDownListTableViewController) -> Int
}

open class UNDDropDownListTableViewController: UITableViewController {
    
    /// Mark : - Interfaces
    public weak var delegate : UNDDropDownListDelegate?
    public var identifierTag : Int?
    public var isMultipleSelectable : Bool {
        get{
            return self.tableView.allowsMultipleSelection
        }
        set(newValue){
            self.tableView.allowsMultipleSelection = newValue
        }
    }
    
    /// Set this property tell us how many cells you what to show up in the Drop Down List each time
    public var numberOfDisplayingCells : Int{
        get{
            return _numberOfDisplayingCells
        }
        set(newValue){
            _ = self.resignFirstResponder()
            _numberOfDisplayingCells = newValue
        }
    }
    
    /// Normally, you should let us know that is the Width of the Dropdown List
    public var width : CGFloat{
        get{
            return _width
        }
        set(newValue){
            _ = self.resignFirstResponder()
            _width = newValue
        }
    }
    
    /// And you'd better tell us what is the origin Point of the Dropdown List
    public var originPoint : CGPoint{
        get{
            return _originPoint
        }
        set(newValue){
            _ = self.resignFirstResponder()
            _originPoint = newValue
        }
    }
    
    /// You need o set this property to let us know should we hide the default seperator for the table view cells or not.... Ifyou want use your custom Seperator, you'd better set this property to YES
    public var shouldHideSeperator : Bool {
        get{
            return hideSeperator
        }
        set(newValue){
            hideSeperator = newValue
            self.setTableViewSeperator()
        }
    }
    
    /// You need to update this property if you want your Drop down list be transparent
    public var dropdownListAlpha : CGFloat = 1
    
    /// You need to update this property if you want your Drop down list show up or hide quicker
    public var dropdownListShowUpAndHideDuration : TimeInterval = 0.5
    
    /// MARK : Read Only Property
    open var dropdownListHeight : CGFloat{
        
        return self.usingCellHeight * CGFloat.init(min(self.numberOfDisplayingCells, getSupportTotalCellRows()))
    }
    
    open var dropdownListOriginPoint : CGPoint {
        return _originPoint
    }
    
    open var dropdownListWidth : CGFloat{
        return _width
    }
    
    private var usingFrame : CGRect{
        return CGRect(origin: dropdownListOriginPoint,
                      size: CGSize(width: dropdownListWidth,
                                   height: dropdownListHeight))
    }
    
    /// MARK : Private Properties
    private var hideSeperator : Bool = false
    private var usingCellHeight : CGFloat = 44.0
    private var usingCellIdentifier : String?
    private var _numberOfDisplayingCells : Int = 5
    private var _width : CGFloat = 0
    private var _originPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    /// MARK : - Public Methods
    public func setupWithTarget(_ target : UNDDropDownListDelegate, showUpView view: UIView, andCell cell : UNDBaseTableViewCell){
        self.registerCell(cell)
        view.addSubview(self.view)
        self.view.alpha = 0
        self.delegate = target
    }
    
    public func registerCell(_ cell: UNDBaseTableViewCell){
        type(of: cell).registerSelf(intoTableView:self.tableView)
        self.usingCellHeight = type(of: cell).cellHeight
        self.usingCellIdentifier = type(of: cell).cellIdentifierName
    }
    
    public func showUp(){
        
        self.view.frame = usingFrame
        self.view.superview?.bringSubview(toFront: self.view)
        
        UNDanielUtilsTool.log("_____ Trying to show Dropdown List:\(self) in superView :\(String(describing: self.view.superview)) in Frame :\(usingFrame)")
        
        UIView.animate(withDuration: self.dropdownListShowUpAndHideDuration) { 
            self.view.alpha = self.dropdownListAlpha
        }
    }
    
    public func reloadData(){
        self.tableView.reloadData()
    }
    
    public func hideDropdownList(){
        if self.view.alpha > 0.0 {
            UIView.animate(withDuration: self.dropdownListShowUpAndHideDuration,
                             animations: { 
                                self.view.alpha = 0.0
            })
        }
    }
    
    public func setUpDispalyingPositionWithView(_ view: UIView, andExtendWidth extendWidth: CGFloat ){
        if let convertedRect = view.superview?.convert(view.frame,
                                                       to: self.view.superview){
            _originPoint = CGPoint(x: convertedRect.origin.x,
                                   y: convertedRect.origin.y + convertedRect.size.height)
            _width = convertedRect.size.width + extendWidth
        } else {
            _originPoint = CGPoint(x: 0,
                                   y: 0)
            _width = 0.0 + extendWidth
        }
    }
    
    open override func resignFirstResponder() -> Bool {
        self.hideDropdownList()
        return super.resignFirstResponder()
    }
    
    /// MARK : - Privete Methods
    ///  MARK : - UI View Controller
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.view.backgroundColor = UIColor.clear
        self.tableView.backgroundView = UIView()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.tableView.bounces = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.alwaysBounceHorizontal = false
        
        self.setTableViewSeperator()
    }

    // MARK: - Table view data source
    override open func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getSupportTotalCellRows()
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.usingCellHeight
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UNDBaseTableViewCell = UNDDDLSampleTableViewCell()
        if let unwrapedCellIdentifier = self.usingCellIdentifier {
            cell = tableView.dequeueReusableCell(withIdentifier: unwrapedCellIdentifier,
                                                 for: indexPath) as! UNDBaseTableViewCell
        }
        
        if let unwrapDelegate = self.delegate {
            var model : Any?
            if unwrapDelegate.responds(to: Selector(("dropdownList:dataAtIndexPath:"))) {
                model = unwrapDelegate.dropdownList(self,
                                                    dataAtIndexPath: indexPath)
            }
            if let unwrapedModel = model {
                cell.setupCell(basedOnModelDictionary: [UNDBaseTableViewCell.UITableViewCell_BaseModle_Key : unwrapedModel])
            }
            
        }
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let unwrapDelegate = self.delegate {
            if unwrapDelegate.responds(to: Selector(("dropdownList:didSelectCellAtIndexPath:"))) {
                unwrapDelegate.dropdownList(self,
                                            didSelectCellAtIndexPath: indexPath)
            }
        }
    }

    /// MARK: - Support Methods
    func setTableViewSeperator() -> Void {
        if !hideSeperator {
            self.tableView.separatorStyle = .singleLine
        } else {
            self.tableView.separatorStyle = .none
        }
    }
    
    func getSupportTotalCellRows() -> Int {
        var returnInt : Int = 0
        if let unwrapDelegate = self.delegate {
            if unwrapDelegate.responds(to: Selector(("numberOfCellsInDropdownList:"))) {
                returnInt = unwrapDelegate.numberOfCellsInDropdownList(self)
            }
        }
        return returnInt
    }

}
