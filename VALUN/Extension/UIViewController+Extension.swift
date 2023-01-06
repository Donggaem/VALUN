//
//  UIViewController+Extension.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/23.
//

import UIKit
import SnapKit
import Foundation

extension UIViewController {
  
  // MARK: UIWindow의 rootViewController를 변경하여 화면전환
  func changeRootViewController(_ viewControllerToPresent: UIViewController) {
    if let window = UIApplication.shared.windows.first {
      window.rootViewController = viewControllerToPresent
      UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    } else {
      viewControllerToPresent.modalPresentationStyle = .overFullScreen
      self.present(viewControllerToPresent, animated: true, completion: nil)
    }
  }
}

//MARK: - Extension UILabel
extension UILabel {
    func setGrayMsg() {
        textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        font = UIFont(name: "SUIT-Bold", size: 12)
    }
    
    func setRedMsg() {
        textColor =  UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1)
        font = UIFont(name: "SUIT-Bold", size: 12)
    }
    
    func setGreenMsg() {
        textColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
        font = UIFont(name: "SUIT-Bold", size: 12)
    }
}

//MARK: - Extension UIButton
extension UIButton {
    func setFalse() {
        backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        isEnabled = false
    }
    
    func setTrue() {
        backgroundColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
        setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        isEnabled = true
    }
}
