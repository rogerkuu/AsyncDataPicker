//
//  AsyncDataPicker.swift
//  AsyncDataPicker
//
//  Created by Mianji GU on 2018/3/28.
//  Copyright © 2018年 Mianji GU. All rights reserved.
//

import UIKit

open class AsyncDataPicker: UIView {
    fileprivate let screenWidth: CGFloat = UIScreen.main.bounds.width
    fileprivate let screenHeight: CGFloat = UIScreen.main.bounds.height
    fileprivate let headerCellIdentifier = "AsyncDataPickerHeaderCell"
    fileprivate let itemCellIdentifier = "AsyncDataPickerItemCell"
    /// translucence background
    fileprivate var backgroundView: UIView!
    /// DataPicker title Label
    fileprivate var titleLabel: UILabel!
    /// table view height
    fileprivate var tableViewHeight: CGFloat = 300
    /// data source
    fileprivate var totalDataArray = [[AsyncDataPickerItemProtocol]]()
    /// selected data
    fileprivate var selectedDataArray = [AsyncDataPickerItemProtocol]()
    /// to show data source
    fileprivate var tableViews = [UITableView]()
    /// menu/section view
    fileprivate var collectionView : UICollectionView!
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate var numberOfComponents = 1
    /// current component
    fileprivate var currentComponent = 0
    /// DataPicker title
    var title = ""
    /// Data provider
    public typealias DataProvider = (_ component: Int, _ parentID: String, _ receiver: @escaping DataReceiver) -> Void
    /// Data Receiver
    public typealias DataReceiver = ([AsyncDataPickerItemProtocol]) -> Void
    /// selected data
    public typealias DataResult = ([AsyncDataPickerItemProtocol?]) -> Void
    
    fileprivate var dataProvider: DataProvider?
    fileprivate var dataResult: DataResult?
    
    public init(numberOfComponents: Int, title: String) {
        super.init(frame: CGRect(x: 0, y: screenHeight, width: screenWidth, height: AsyncDataPickerAttribute.totalHeight))
        self.backgroundColor = UIColor.white
        
        tableViewHeight = frame.height - AsyncDataPickerAttribute.titleHeight - AsyncDataPickerAttribute.tabbarHeight - 1
        self.numberOfComponents = numberOfComponents
        self.title = title
        setupUI()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {[unowned self] () in
            self.setYPosition(self.screenHeight - AsyncDataPickerAttribute.totalHeight)
        })
    }
    
    public func hide() {
        weak var weakself = self
        UIView.animate(withDuration: 0.3, animations: {
            weakself?.setYPosition(self.screenHeight)
        }, completion: { (finished) in
            weakself?.backgroundView.removeFromSuperview()
            weakself?.removeFromSuperview()
        })
    }
    
    private func setYPosition(_ Y:CGFloat) {
        let oldRect = frame
        let newRect = CGRect(x: oldRect.origin.x, y: Y, width: oldRect.width, height: oldRect.height)
        frame = newRect
    }
}

// MARK: - Initialize UI
extension AsyncDataPicker {
    fileprivate func setupUI() {
        setupBackground()
        
        setupTitleView()
        addSubview(titleLabel)
        
        addSubview(createLineView(frame: CGRect(x: 0, y: AsyncDataPickerAttribute.titleHeight, width: screenWidth, height: 0.5)))
        
        setupCollectionView()
        addSubview(collectionView)
        
        addSubview(createLineView(frame: CGRect(x: 0,
                                                y: AsyncDataPickerAttribute.titleHeight + AsyncDataPickerAttribute.tabbarHeight + 0.5,
                                                width: screenWidth,
                                                height: 0.5)))
        
        setupScrollView()
        addSubview(scrollView)
        
        setupTableView()
    }
    
    private func setupBackground() {
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.4
        backgroundView.isUserInteractionEnabled = true
        backgroundView.contentMode = .scaleToFill
        backgroundView.isHidden = true
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.tapBackgroundView(tap:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1 
        backgroundView.addGestureRecognizer(tap)
        
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
    }
    
    private func setupTitleView() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: AsyncDataPickerAttribute.titleHeight))
        titleLabel.textColor = AsyncDataPickerAttribute.normalTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        
    }
    
    /// setup menu/section view
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0,
                                                        y: AsyncDataPickerAttribute.titleHeight + 0.5,
                                                        width: screenWidth,
                                                        height: AsyncDataPickerAttribute.tabbarHeight),
                                          collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AsyncDataPickerHeaderCell", bundle: nil), forCellWithReuseIdentifier: headerCellIdentifier)
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0,
                                                y: AsyncDataPickerAttribute.titleHeight + AsyncDataPickerAttribute.tabbarHeight + 1,
                                                width: screenWidth,
                                                height: tableViewHeight))
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: screenWidth, height: tableViewHeight)
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
    }
    
    fileprivate func setupTableView() {
        let tableView = UITableView(frame: CGRect(x: screenWidth * CGFloat(tableViews.count),
                                                  y: 0,
                                                  width: screenWidth,
                                                  height: tableViewHeight),
                                    style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "AsyncDataPickerItemCell", bundle: nil), forCellReuseIdentifier: itemCellIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableViews.append(tableView)
        scrollView.addSubview(tableView)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(tableViews.count), height: tableViewHeight)
    }
    
    private func createLineView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = AsyncDataPickerAttribute.separatorColor
        return view
    }
    
    @objc func tapBackgroundView(tap: UITapGestureRecognizer) {
        hide()
    }
}

// MARK: - Config data provider
extension AsyncDataPicker {
    
    public func configDataProvider(_ provider: @escaping DataProvider) {
        dataProvider = provider
        
        currentComponent = 0
        loadNextData(parentID: "")
    }
    
    public func dataSelectedAction(_ result: @escaping DataResult) {
        dataResult = result
    }
    
    fileprivate func loadNextData(parentID: String) {
        let dataComponent = currentComponent
        if dataComponent > numberOfComponents - 1 {
            resultCallBack()
            return
        }
        
        dataProvider?(dataComponent, parentID, { [unowned self] (itemArray) in
            if itemArray.count > 0 {
                if dataComponent == self.totalDataArray.count  {
                    //add next component data
                    self.totalDataArray.append(itemArray)
                    //add next component tableview
                    self.setupTableView()
                    
                    //scroll animation
                    UIView.animate(withDuration: 0.3, animations: {
                        self.scrollView.contentOffset = CGPoint(x: self.screenWidth * CGFloat(dataComponent), y: self.scrollView.contentOffset.y)
                    })
                    self.scrollView.contentSize = CGSize(width: self.screenWidth * CGFloat(dataComponent+1), height: self.scrollView.contentSize.height)
                    
                    let item = AsyncDataPickerModel()
                    item.name = AsyncDataPickerAttribute.defaultComponentTitle
                    self.selectedDataArray.append(item)
                }
            } else {
                // 没有内容直接返回
                self.resultCallBack()
                return
            }
            
            self.tableViews[dataComponent].reloadData()
            self.collectionView.reloadData()
        })
    }
    
    fileprivate func resultCallBack() {
        var resultArray = [AsyncDataPickerItemProtocol?]()
        for index in 0 ..< numberOfComponents {
            if index <= selectedDataArray.count - 1 {
                resultArray.append(selectedDataArray[index])
            } else {
                resultArray.append(nil)
            }
        }
        dataResult?(resultArray)
        hide()
    }
}

// MARK: - CollectonView Delegate & DataSource
extension AsyncDataPicker: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier, for: indexPath) as! AsyncDataPickerHeaderCell
        if selectedDataArray.count > 0 {
            cell.model = selectedDataArray[indexPath.row]
            // 选中状态
            cell.titleLabel.textColor = AsyncDataPickerAttribute.normalTextColor
            if currentComponent == indexPath.row || indexPath.row == selectedDataArray.count - 1 {
                cell.titleLabel.textColor = AsyncDataPickerAttribute.selectedTextColor
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentComponent = indexPath.row
        
        totalDataArray.removeSubrange(Range(currentComponent + 1 ..< totalDataArray.count))
        UIView.animate(withDuration: 0.3, animations: {[unowned self] () in
            self.scrollView.contentOffset = CGPoint(x: self.screenWidth * CGFloat(self.currentComponent), y: self.scrollView.contentOffset.y)
        })
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(currentComponent+1), height: scrollView.contentSize.height)
        
        for (index,value) in tableViews.enumerated() {
            if index > indexPath.row {
                value.removeFromSuperview()
            }
        }
        tableViews.removeSubrange(Range(currentComponent + 1 ..< tableViews.count))
        selectedDataArray.removeSubrange(Range(currentComponent + 1 ..< selectedDataArray.count))

        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let model = selectedDataArray[indexPath.row]
        let width = widthForsize(text: model.pickerItemName, size: CGSize(width:10000, height:35), font: 14)
        return CGSize(width: width + 20, height:40)
    }
    
    public func widthForsize(text:String, size:CGSize,font:CGFloat) -> CGFloat{
        let attrbute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: font)]
        let nsStr = NSString(string: text)
        return nsStr.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading,.truncatesLastVisibleLine], attributes: attrbute, context: nil).size.width
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}

// MARK: - TableView Delegate & DataSource
extension AsyncDataPicker: UITableViewDelegate,UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = 0
        let tableIndex = tableViews.index(of: tableView)!
        if totalDataArray.count > 0 && tableIndex < totalDataArray.count {
            rowsCount = totalDataArray[tableIndex].count
        }
        return rowsCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath) as! AsyncDataPickerItemCell
        cell.selectionStyle = .none
        let tableIndex = tableViews.index(of: tableView)!
        
        let dataArray = totalDataArray[tableIndex]
        let model = dataArray[indexPath.row]
        cell.model = model
        
        cell.titleLabel.textColor = AsyncDataPickerAttribute.normalTextColor
        cell.accessoryType = .none
        cell.tintColor = AsyncDataPickerAttribute.selectedTextColor
        if model.pickerItemID == selectedDataArray[tableIndex].pickerItemID {
            cell.titleLabel.textColor = AsyncDataPickerAttribute.selectedTextColor
            cell.accessoryType = .checkmark
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let tableIndex = tableViews.index(of: tableView)!
        let dataArray = totalDataArray[tableIndex]
        let model = dataArray[indexPath.row]
        
        selectedDataArray[tableIndex] = model
        
        currentComponent = tableIndex + 1
        loadNextData(parentID: model.pickerItemID)
        
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentComponent == numberOfComponents {
            resultCallBack()
        } else {
            tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
