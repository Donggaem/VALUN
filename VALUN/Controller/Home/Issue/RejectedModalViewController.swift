//
//  RejectedModalViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/03.
//

import UIKit

class RejectedModalViewController: UIViewController {

    @IBOutlet var modalView: UIView!
    
    @IBOutlet var rejectTextView: UITextView!
    
    @IBOutlet var rejectSendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    
    //MARK: - IBAction
    @IBAction func rejectSendBtnPressed(_ sender: UIButton) {
        
    }
    
    //MARK: Func
    private func setUI() {
        modalView.layer.cornerRadius = 10
        
        rejectTextView.layer.cornerRadius = 10
        rejectTextView.layer.borderWidth = 1
        rejectTextView.layer.borderColor = UIColor(red: 0.886, green: 0.886, blue: 0.886, alpha: 1).cgColor
        
        rejectSendBtn.layer.cornerRadius = 10
    }
    
    //백그라운드 터치시 뷰컨 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
