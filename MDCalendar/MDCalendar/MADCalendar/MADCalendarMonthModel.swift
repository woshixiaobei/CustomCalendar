//
//  MADCalendarMonthModel.swift
//  OstrichBlockChain
//
//  Created by 梁宪松 on 2018/10/31.
//  Copyright © 2018 ipzoe. All rights reserved.
//

import UIKit

enum MADCalndarWeek: Int {
    case sunday     = 0
    case monday     = 1
    case thuesday   = 2
    case wednesday  = 3
    case thursday   = 4
    case friday     = 5
    case saturday   = 6
}

enum MADDayTag: Int {
    case currentMonth   = 0
    case perviousMonth  = 1
    case nextMonth      = 2
}

class MADCalendarDayModel: NSObject {
    
    var day: Int = 0
    
    var isToday: Bool = false
    
    var dayTag: MADDayTag = .currentMonth
  
    var isWeekTag: Bool = false
  
    var isSelected: Bool = false
}

class MADCalendarMonthModel: NSObject {

    var date: Date? {
        willSet {
            if let _ = newValue {
                // privious date
                guard let priviousDate = newValue!.mad_previousMonthDate() else {
                    return
                }
//                // next date
//                guard let nextDate = newValue!.mad_nextMonthDate() else {
//                    return
//                }
                
                totalDays = newValue!.mad_daysInMonth()
                firstWeakdays = newValue!.mad_firstWeekDayInMonth()
                year = newValue!.mad_year()
                month = newValue!.mad_month()

                var totalNums = totalDays+firstWeakdays
                totalNums = (totalNums % 7) == 0 ? totalNums : (totalNums + 7 - (totalNums % 7))
                for index in 0..<totalNums {
                    
                    let model = MADCalendarDayModel.init()
                    
                    // if is pervious days
                    if index < firstWeakdays {
                        model.day = priviousDate.mad_daysInMonth() - (firstWeakdays - index) + 1
                        model.dayTag = MADDayTag.perviousMonth
                    }
                    // next month days
                    else if index >= (firstWeakdays + totalDays) {
                        
                        model.day = index - totalDays - firstWeakdays + 1
                        model.dayTag = MADDayTag.nextMonth
                    }
                    // current month days
                    else {
                        model.day = index - firstWeakdays + 1
                        model.dayTag = MADDayTag.currentMonth
                      
                        let currentDate = Date()
                        // current day
                        if  month == currentDate.mad_month(),
                            year == currentDate.mad_year(),
                            index == currentDate.mad_day() + firstWeakdays - 1 {
                            model.isToday = true
                        }
                    }
                    
                    dayArr.append(model)
                }
            }
        }
    }

    /// the num of days of this month
    var totalDays: Int = 0
    
    var firstWeakdays: Int = 0
    
    var year: Int = 0
    
    var month: Int = 0
    
    var dayArr = [MADCalendarDayModel]()
    
    static func modelWithDate(date: Date?) -> MADCalendarMonthModel {
     
        let model = MADCalendarMonthModel.init()
        model.date = date
        return model
    }
}
