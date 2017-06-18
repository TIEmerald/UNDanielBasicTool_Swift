//
//  UNDDropDownListTableViewController.swift
//  Pods
//
//  Created by 尓健 倪 on 17/6/17.
//
//

import UIKit

protocol UNDDropDownListDelegate : NSObjectProtocol {
    
    func dropdownList(_ dropdownList: UNDDropDownListTableViewController, didSelectCellAtIndexPath indexPath: IndexPath) -> Void
    
    func dropdownList(_ dropdownList: UNDDropDownListTableViewController, dataAtIndexPath indexPath: IndexPath) -> Any
    
    func numberOfCellsInDropdownList(_ dropdownList: UNDDropDownListTableViewController) -> Int
}

class UNDDropDownListTableViewController: UITableViewController {
    
    /// Mark : - Interfaces
    public weak var delegate : UNDDropDownListDelegate?
    
    /// Set this property tell us how many cells you what to show up in the Drop Down List each time
    public var numberOfDisplayingCells : Int{
        get{
            return _numberOfDisplayingCells
        }
        set(newValue){
            self.resignFirstResponder()
            _numberOfDisplayingCells = newValue
        }
    }
    
    /// Normally, you should let us know that is the Width of the Dropdown List
    public var width : CGFloat{
        get{
            return _width
        }
        set(newValue){
            self.resignFirstResponder()
            _width = newValue
        }
    }
    
    /// And you'd better tell us what is the origin Point of the Dropdown List
    public var originPoint : CGPoint{
        get{
            return _originPoint
        }
        set(newValue){
            self.resignFirstResponder()
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
        return self.usingCellHeight * CGFloat.init(self.numberOfDisplayingCells)
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
    private var usingCellHeight : CGFloat = 0.0
    private var usingCellIdentifier : String = ""
    private var _numberOfDisplayingCells : Int = 5
    private var _width : CGFloat = 0
    private var _originPoint : CGPoint = CGPoint(x: 0, y: 0)
    
    /// MARK : - Public Methods
    public func setupWithTarget(_ target : UNDDropDownListDelegate, showUpView view: UIView, andCell cell : UITableViewCell){
        self.registerCell(cell)
        view.addSubview(self.view)
        self.view.alpha = 0
        self.delegate = target
    }
    
    public func registerCell(_ cell: UITableViewCell){
        type(of: cell).registerSelf(intoTableView:self.tableView)
        self.usingCellHeight = type(of: cell).cellHeight
        self.usingCellIdentifier = type(of: cell).cellIdentifierName
    }
    
    public func showUp(){
        
        self.view.frame = usingFrame
        self.view.superview?.bringSubview(toFront: self.view)
        
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
    
    open override func resignFirstResponder() -> Bool {
        self.hideDropdownList()
        return super.resignFirstResponder()
    }
    
    /// MARK : - Privete Methods
    ///  MARK : - UI View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.view.backgroundColor = UIColor.clear
        // We will register UNDDDLSampleTableViewCell just in case
        self.registerCell(UNDDDLSampleTableViewCell())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.tableView.bounces = false
        self.tableView.alwaysBounceVertical = false
        self.tableView.alwaysBounceHorizontal = false
        
        self.setTableViewSeperator()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let unwrapDelegate = self.delegate {
            if unwrapDelegate.responds(to: Selector(("numberOfCellsInDropdownList:"))) {
                return unwrapDelegate.numberOfCellsInDropdownList(self)
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UNDDDLSampleTableViewCell.cellIdentifierName,
                                                                   for: indexPath)
        do{
            cell = tableView.dequeueReusableCell(withIdentifier: self.usingCellIdentifier, for: indexPath)
        } catch {
            // No need to handle any thing.. If failed to get the using cell, we will us UNDDDLSampleTableViewCell.
        }
        
        if let unwrapDelegate = self.delegate {
            var model : Any?
            if unwrapDelegate.responds(to: Selector(("dropdownList:dataAtIndexPath:"))) {
                model = unwrapDelegate.dropdownList(self,
                                                    dataAtIndexPath: indexPath)
            }
            if let unwrapedModel = model {
                cell.setupCell(basedOnModelDictionary: [UITableViewCell.UITableViewCell_BaseModle_Key : unwrapedModel])
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

}
