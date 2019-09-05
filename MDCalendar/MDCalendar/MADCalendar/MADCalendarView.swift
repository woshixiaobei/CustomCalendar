//
//  MADCalendarView.swift
//  OstrichBlockChain
//
//  Created by 梁宪松 on 2018/10/31.
//  Copyright © 2018 ipzoe. All rights reserved.
//

import UIKit

class MADCalendarView: UIView {

    /// symbols of a day in a week
    let weekTitles = [
        "SUN", "MON", "TUES", "WED", "THURS", "FRI", "SAT",
    ]
    
    /// current month data
    var currentMonthData: MADCalendarMonthModel!

    /// history month data model
    var calendarMonthDataArr = [MADCalendarMonthModel]()
    
    /// calendar header view
    lazy var calendarHeaderView: MADCalendarHeader = {
        
        let view = MADCalendarHeader.init(frame: CGRect.zero)
        view.delegate = self
        return view
    }()
    
    /// collectionview layout
    lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    /// calendar collectionview
    lazy var calenderCollectionView: UICollectionView = {
       
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        // register collectionview cell
        collectionView.register(MADCalendarCell.self, forCellWithReuseIdentifier: String.init(describing: MADCalendarCell.self))
        
        return collectionView
    }()
    
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(calendarHeaderView)
        addSubview(calenderCollectionView)
        
        // add swipe gesture
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeLeft))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeRight))
        rightSwipe.direction = .right
        
        calenderCollectionView.addGestureRecognizer(leftSwipe)
        calenderCollectionView.addGestureRecognizer(rightSwipe)

        setupInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  // MARK: initialize
  func setupInitialization() {
    
    calendarMonthDataArr.removeAll()
    
    let currentDate = Date()
    
    // 计算出前6个月的数据
    var tempdate = currentDate
    for _ in 0..<6 {
      tempdate = tempdate.mad_previousMonthDate()!
      let previousMonthModel = MADCalendarMonthModel.modelWithDate(date: tempdate)
      calendarMonthDataArr.append(previousMonthModel)
    }
    calendarMonthDataArr.reverse()
    
    currentMonthData = MADCalendarMonthModel.modelWithDate(date: currentDate)
    calendarMonthDataArr.append(currentMonthData)
    calendarHeaderView.dateButton.setTitle("\(currentMonthData.year)年\(currentMonthData.month)月", for: .normal)
    
    let nextMonthModel = MADCalendarMonthModel.modelWithDate(date: currentDate.mad_nextMonthDate())
    calendarMonthDataArr.append(nextMonthModel)
  }
    
    // MARK: Event Handler
    @objc func swipeLeft(swipte: UISwipeGestureRecognizer) {
        nextMonth()
    }
    
    @objc func swipeRight(swipte: UISwipeGestureRecognizer) {
       previousMonth()
    }
    
    /// get the current index of target obj in calendarMonthDataArr
    ///
    /// - Parameter model: target object
    /// - Returns: --
    func monthIndexOf(model: MADCalendarMonthModel) -> Int {
        
        for (index, item) in calendarMonthDataArr.enumerated() {
            if item.date == model.date {
                return index
            }
        }
        return -1
    }
    
    func performSwipeAnimation(subType: CATransitionSubtype) {
        let transition = CATransition.init()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = subType as String
        calenderCollectionView.layer.add(transition, forKey: nil)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        calendarHeaderView.frame = CGRect.init(x: 0,
                                                    y: 0,
                                                    width: frame.width,
                                                    height: 64)
        calenderCollectionView.frame = CGRect.init(x: 20,
                                                        y: calendarHeaderView.frame.maxY - 10,
                                                        width: frame.width - 40,
                                                        height: frame.height - calendarHeaderView.frame.height - 10)

    }
  
  /// 前一个月
  func previousMonth() {
    let usedIndex = monthIndexOf(model: currentMonthData)
    guard (usedIndex - 1) >= 0 else {
      return
    }
    
    currentMonthData = calendarMonthDataArr[usedIndex - 1]
//    if let currentDate = currentMonthData.date {
//      let nextMonthData = calendarMonthDataArr[usedIndex]
//      let previousMonthData = MADCalendarMonthModel.modelWithDate(date: currentDate.mad_previousMonthDate())
//
//      calendarMonthDataArr.removeAll()
//      calendarMonthDataArr.append(previousMonthData)
//      calendarMonthDataArr.append(currentMonthData)
//      calendarMonthDataArr.append(nextMonthData)
//    }
//
    
    calendarHeaderView.dateButton.setTitle("\(currentMonthData.year)年\(currentMonthData.month)月", for: .normal)
    performSwipeAnimation(subType: kCATransitionFromLeft as CATransitionSubtype)
    calenderCollectionView.reloadData()
  }
  
  /// 后一个月
  func nextMonth() {
    let usedIndex = monthIndexOf(model: currentMonthData)
    guard (usedIndex + 1) < calendarMonthDataArr.count,
      usedIndex >= 0 else {
        return
    }
    
    
    currentMonthData = calendarMonthDataArr[usedIndex + 1]
//    if let currentDate = currentMonthData.date {
//      let previousMonthData = calendarMonthDataArr[usedIndex]
//      let nextMonthData = MADCalendarMonthModel.modelWithDate(date: currentDate.mad_nextMonthDate())
//
//      calendarMonthDataArr.removeAll()
//      calendarMonthDataArr.append(previousMonthData)
//      calendarMonthDataArr.append(currentMonthData)
//      calendarMonthDataArr.append(nextMonthData)
//    }
//
    calendarHeaderView.dateButton.setTitle("\(currentMonthData.year)年\(currentMonthData.month)月", for: .normal)
    performSwipeAnimation(subType: kCATransitionFromRight as CATransitionSubtype)
    calenderCollectionView.reloadData()
  }
}


extension MADCalendarView: MonthProtocol {
  
  func clickToNextMonth(_ tag: ButtonClickTag) {
    if tag == .PreviousButtonClick {
      // 前一个
      previousMonth()
    } else {
      // 后一个
      nextMonth()
    }
  }
}
extension MADCalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currentMonthData.dayArr.count + weekTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: MADCalendarCell.self), for: indexPath) as! MADCalendarCell
        
        if indexPath.row < weekTitles.count {
          
            cell.titleLabel.text = weekTitles[indexPath.row]
            cell.titleLabel.textColor = UIColor.green

        }else {
            let index = indexPath.row - weekTitles.count
            if index < currentMonthData.dayArr.count {
                cell.model = currentMonthData.dayArr[index]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if currentMonthData.dayArr.count > 0 {
            let rowNums = currentMonthData.dayArr.count / 7 + 1
            return CGSize.init(width: calenderCollectionView.frame.width/7,
                                                   height: calenderCollectionView.frame.height/CGFloat(rowNums))
        } else {
            return CGSize.init(width: calenderCollectionView.frame.width/7,
                                                   height: calenderCollectionView.frame.height/7)
        }
    }
}

