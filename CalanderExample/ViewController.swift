//
//  ViewController.swift
//  CalanderExample
//
//  Created by Hitendra on 28/12/20.
//  Copyright © 2020 Hitendra. All rights reserved.
//

import UIKit
// Testing from branch testBranch
// New TestBranch Commit
class ViewController: UIViewController {
    
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var btnSelectDate : UIButton!
    @IBOutlet weak var viewHeader : UIView!
    
    var selectDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSelectDate.backgroundColor = .white
        self.btnSelectDate.layer.borderWidth = 1.0
        self.btnSelectDate.layer.borderColor = UIColor.gray.cgColor
        self.btnSelectDate.layer.cornerRadius = 10.0
        self.btnSelectDate.dropShadow()
        
        //self.viewHeader.clipsToBounds = true
//        self.viewHeader.backgroundColor = .red
//        self.viewHeader.layer.borderWidth = 1.0
//        self.viewHeader.layer.borderColor = UIColor.gray.cgColor
//        self.viewHeader.layer.cornerRadius = 10.0
        
        self.viewHeader.backgroundColor = .red
        self.viewHeader.layer.cornerRadius = 10.0
        self.viewHeader.layer.borderWidth = 1.0
        self.viewHeader.dropShadow()
        
        self.selectDate = Date()
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.lblDate.text = dateFormatter.string(from: Date())
    }
    static func getViewController(_ identifier : String) -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    @IBAction func openDate(_ sender : UIButton){
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let calanderVC = ViewController.getViewController(String(describing: CalanderVC.self)) as! CalanderVC
        if(selectDate != nil){
            calanderVC.selectedDate = selectDate as NSDate?
        }
        calanderVC.selectDate = { [weak self] (date) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectDate = date as Date
            strongSelf.lblDate.text = dateFormatter.string(from: date as Date)
        }
        calanderVC.closeViewController = { [weak self] (viewCon) in
            guard self != nil else {
                return
            }
            viewCon.dismiss(animated: false, completion: nil)
        }
        calanderVC.presentViewControllerForViewController(self)
        calanderVC.borderShow(2.0, 10.0)
    }
}

