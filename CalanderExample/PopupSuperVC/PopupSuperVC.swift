//
//  PopupSuperVC.swift
//  CalanderExample
//
//  Created by Hitendra on 29/12/20.
//  Copyright © 2020 Hitendra. All rights reserved.
//

import UIKit

class PopupSuperVC : UIViewController {

    var closeViewController : ((UIViewController) -> Void)?
    lazy var containerView = UIView()
    lazy var testVC = UIViewController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func borderShow(borderColor : UIColor = .gray, _ width : CGFloat = 0.5, _ corderRadius : CGFloat = 5){
        self.testVC.view.dropShadow()
        self.containerView.layer.borderWidth = width
        self.containerView.layer.borderColor = borderColor.cgColor
        self.containerView.layer.cornerRadius = corderRadius
        self.containerView.layer.masksToBounds = true
    }
    
    func presentViewControllerForViewController(_ viewConteroler : UIViewController){
        if Constants.IsiPhone{
            testVC.modalPresentationStyle = .custom
            viewConteroler.present(testVC, animated: false, completion: nil)
            testVC.view.backgroundColor = UIColor.init(white: 0.000, alpha: 0.200)
            let frame = self.view.frame
            self.view.frame = frame
            containerView.frame = self.view.bounds
            containerView.addSubview(self.view)
            testVC.view.addSubview(containerView)
            testVC.addChild(self)
            self.containerView.center = testVC.view.center
            self.setGestureRecognizer(testVC)
        }
    }
    func setGestureRecognizer(_ objView : UIViewController){
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hidePopupIphoneView))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.delegate = self
        objView.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func hidePopupIphoneView(){
        if self.closeViewController != nil {
            self.closeViewController!(self)
        }
    }
}

extension PopupSuperVC : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: self.view)) {
            return false // ignore the touch
        }
        return true
    }
}

extension UIView {
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
    }
}
