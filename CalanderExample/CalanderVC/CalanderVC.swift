//
//  CalanderVC.swift
//  CalanderExample
//
//  Created by Hitendra on 28/12/20.
//  Copyright © 2020 Hitendra. All rights reserved.
//


import UIKit

class POCalendarDateCell: UICollectionViewCell{
    
    @IBOutlet weak var lblDate : UILabel!
}

enum POCalendarVCStartDay : Int{
    case  POCalendarVCStartDaySunday = 1
    case  POCalendarVCStartDayMonday = 2
}

class CalanderVC: PopupSuperVC {
    
    var selectDate : ((NSDate) -> Void)?

    var monthShowing : NSDate?
    var selectedDate : NSDate?
    var dateFormatter : DateFormatter?
    var onlyShowCurrentMonth : Bool = false
    
    var calendarStartDay : POCalendarVCStartDay?
    
    var calendar : NSCalendar?
    var arrDates : NSArray?
    
    var arraySelectedDates = NSMutableArray()
    
    @IBOutlet weak var collDateList : UICollectionView!
    @IBOutlet weak var lblMonth : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        self.calendar?.locale = NSLocale.current
        self.calendar?.firstWeekday = 1
        if (self.dateFormatter == nil){
            self.dateFormatter = DateFormatter.init()
            self.dateFormatter?.timeStyle = .none
            self.dateFormatter?.dateFormat = "LLLL yyyy"
        }
        if (self.monthShowing == nil){
            self.monthShowing = NSDate()
        }
        resetCalenderDates()
        let longPressRecognizer = UILongPressGestureRecognizer.init()
        longPressRecognizer.addTarget(self, action: #selector(didLongPress))
        longPressRecognizer.minimumPressDuration = 0.2
        self.collDateList.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func didLongPress(_ gesture : UILongPressGestureRecognizer){
        if gesture.state == .began {
            let location = gesture.location(in: self.collDateList)
            let indexPath = self.collDateList.indexPathForItem(at: location)
            if indexPath != nil{
                let date = arrDates![indexPath!.row] as? Date
                self.arraySelectedDates.add(date! as Date)
            }
            
        }
        else if gesture.state == .changed{
            let location = gesture.location(in: self.collDateList)
            let indexPath = self.collDateList.indexPathForItem(at: location)
            if indexPath != nil{
                let date = arrDates![indexPath!.row] as? Date
                self.arraySelectedDates.add(date! as Date)
            }
        }
        else if gesture.state == .ended{
            let location = gesture.location(in: self.collDateList)
            let indexPath = self.collDateList.indexPathForItem(at: location)
            if indexPath != nil{
              let date = arrDates![indexPath!.row] as? Date
                self.arraySelectedDates.add(date! as Date)
            }
            self.collDateList.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // IBAction Method - Move next month
    @IBAction func moveCalendarToNextMonth(_ sender : UIButton){
        var comps = DateComponents()
        comps.month = 1
        let newMonth = calendar?.date(byAdding: comps, to: monthShowing! as Date, options: [])
        monthShowing = newMonth as NSDate?
        resetCalenderDates()
        collDateList.reloadData()
    }
    @IBAction func moveCalendarToPreviousMonth(_ sender : UIButton){
        var comps = DateComponents()
        comps.month = -1
        let newMonth = calendar!.date(byAdding: comps, to: monthShowing! as Date, options: [])
        monthShowing = newMonth as NSDate?
        resetCalenderDates()
        collDateList.reloadData()
    }
    func resetCalenderDates() {
        arrDates = nil
        var date = _firstDayOfMonthContaining(monthShowing as Date?)
        if !onlyShowCurrentMonth {
            while _placeInWeek(for: date) != 0 {
                date = _previousDay(date)
            }
        }
        var endDate = _firstDayOfNextMonthContaining(monthShowing as Date?)
        if !onlyShowCurrentMonth {
            var comps = DateComponents()
            comps.weekOfMonth = self._numberOfWeeks(inMonthContaining: monthShowing as Date?)
            endDate = calendar!.date(byAdding: comps, to: date!, options: [])
        }
        var arrDates: [AnyHashable] = []
        if let endDate = endDate {
            while date!.laterDate(endDate) != date {
                arrDates.append(date)
                date = _nextDay(date)
            }
        }
        self.arrDates = arrDates as NSArray
        lblMonth.text = dateFormatter!.string(from: monthShowing! as Date)
        collDateList.reloadData()
        
    }
    
    func _firstDayOfMonthContaining(_ date: Date?) -> Date? {
        var comps: DateComponents? = nil
        if let date = date {
            comps = calendar!.components([.year, .month, .day], from: date)
        }
        comps?.day = 1
        if let comps = comps {
            return calendar!.date(from: comps)
        }
        return nil
    }
    func _firstDayOfNextMonthContaining(_ date: Date?) -> Date? {
        var comps: DateComponents? = nil
        if let date = date {
            comps = calendar!.components([.year, .month, .day], from: date)
        }
        comps?.day = 1
        comps!.month = (comps?.month ?? 0) + 1
        if let tempcomps = comps {
            return calendar!.date(from: tempcomps)
        }
        return nil
    }
    func _previousDay(_ date: Date?) -> Date? {
        var comps = DateComponents()
        comps.day = -1
        if let date = date {
            return calendar!.date(byAdding: comps, to: date, options: [])
        }
        return nil
    }
    func _nextDay(_ date: Date?) -> Date? {
        var comps = DateComponents()
        comps.day = 1
        if let date = date {
            return calendar!.date(byAdding: comps, to: date, options: [])
        }
        return nil
    }
    
    func _placeInWeek(for date: Date?) -> Int {
        var compsFirstDayInMonth: DateComponents? = nil
        if let date = date {
            compsFirstDayInMonth = calendar!.components(.weekday, from: date)
        }
        let dayestoMultpil = ((compsFirstDayInMonth?.weekday ?? 0) - 1 - calendar!.firstWeekday + 8)
        return dayestoMultpil % 7
    }
    func _numberOfWeeks(inMonthContaining date: Date?) -> Int {
        if let date = date {
            return calendar!.range(of: .weekOfMonth, in: .month, for: date).length
        }
        return 0
    }
    
    func _dateIsToday(_ date: Date?) -> Bool {
        return self.date(Date(), isSameDayAs: date)
    }
    
    func date(_ date1: Date?, isSameDayAs date2: Date?) -> Bool {
        // Both dates must be defined, or they're not the same
        if date1 == nil || date2 == nil {
            return false
        }
        
        var day: DateComponents? = nil
        if let date1 = date1 {
            day = calendar!.components([.era, .year, .month, .day], from: date1)
        }
        var day2: DateComponents? = nil
        if let date2 = date2 {
            day2 = calendar!.components([.era, .year, .month, .day], from: date2)
        }
        return day2?.day == day?.day && day2?.month == day?.month && day2?.year == day?.year && day2?.era == day?.era
    }
    func _compare(byMonth date: Date?, to otherDate: Date?) -> ComparisonResult {
        var day: DateComponents? = nil
        if let date = date {
            day = calendar!.components([.year, .month], from: date)
        }
        var day2: DateComponents? = nil
        if let otherDate = otherDate {
            day2 = calendar!.components([.year, .month], from: otherDate)
        }
        
        if (day?.year ?? 0) < (day2?.year ?? 0) {
            return .orderedAscending
        } else if (day?.year ?? 0) > (day2?.year ?? 0) {
            return .orderedDescending
        } else if (day?.month ?? 0) < (day2?.month ?? 0) {
            return .orderedAscending
        } else if (day?.month ?? 0) > (day2?.month ?? 0) {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
}


extension CalanderVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDates!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "POCalendarDateCell", for: indexPath) as? POCalendarDateCell
        let date = arrDates![indexPath.row] as? Date
        if let date = date {
            let comps = calendar!.components([.day, .month], from: date)
            cell?.lblDate.text = String(format: "%ld", comps.day!)
        } else {
            cell?.lblDate.text = ""
        }
        
        if (selectedDate != nil) && self.date(selectedDate as Date?, isSameDayAs: date) {
            cell!.lblDate.textColor = UIColor.white
            cell!.lblDate.backgroundColor = UIColor(red: 255 / 255.0, green: 159 / 255.0, blue: 0.0 / 255.0, alpha: 1)
        } else if _dateIsToday(date) {
            cell!.lblDate.textColor = UIColor.white
            cell!.lblDate.backgroundColor = UIColor(red: 22 / 255.0, green: 19 / 255.0, blue: 36.0 / 255.0, alpha: 1)
            
        } else if !onlyShowCurrentMonth && self._compare(byMonth: date, to: monthShowing as Date?) != .orderedSame    {
            cell!.lblDate.textColor = UIColor(white: 0.667, alpha: 1.000)
            cell!.lblDate.backgroundColor = UIColor.clear
        } else {
            cell!.lblDate.textColor = UIColor.black
            cell!.lblDate.backgroundColor = UIColor.clear
        }
        
        if self.arraySelectedDates.contains(date! as Date){
           cell!.lblDate.textColor = UIColor.white
            cell!.lblDate.backgroundColor = UIColor(red: 255 / 255.0, green: 159 / 255.0, blue: 0.0 / 255.0, alpha: 1)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = (arrDates![indexPath.row] as! NSDate)
        
        if !onlyShowCurrentMonth && self._compare(byMonth: selectedDate as Date?, to: monthShowing as Date?) != .orderedSame {
            monthShowing = selectedDate
            resetCalenderDates()
        } else {
            collectionView.reloadData()
        }
        if(self.selectDate != nil){
           self.selectDate!(selectedDate!)
        }
    }
}

extension Date{
    
    func laterDate(_ date : Date) -> Date{
        if date > self {
            return date
        }
        return date
    }
}
