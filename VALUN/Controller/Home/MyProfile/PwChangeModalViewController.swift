//
//  PwChangeViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit

class PwChangeModalViewController: UIViewController {

    @IBOutlet var modalView: UIView!
    @IBOutlet var nowPwLabel: UILabel!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var pwMsgLabel: UILabel!
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwCheckMsgLabel: UILabel!
    @IBOutlet var pwChangeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    

    @IBAction func pwChangeBtnPressed(_ sender: UIButton) {
    }
    
    //MARK: - INNER Func
    
    //백그라운드 터치시 뷰컨 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setUI() {
        
        modalView.layer.cornerRadius = 10
        
        pwTextField.layer.cornerRadius = 10
        pwTextField.layer.borderWidth = 1
        pwTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        pwCheckTextField.layer.cornerRadius = 10
        pwCheckTextField.layer.borderWidth = 1
        pwCheckTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        pwChangeBtn.layer.cornerRadius = 10
    }
}
