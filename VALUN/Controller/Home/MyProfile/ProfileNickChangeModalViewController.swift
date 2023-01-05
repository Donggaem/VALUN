//
//  ProfileNickChangeViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit

class ProfileNickChangeModalViewController: UIViewController {

    @IBOutlet var modalView: UIView!
    
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nickChangeTextField: UITextField!
    @IBOutlet var nickOverlapBtn: UIButton!
    @IBOutlet var nickMsgLabel: UILabel!
    @IBOutlet var nickChangeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    

    @IBAction func nickOverlapBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func nickChangeBtnPressed(_ sender: UIButton) {
        
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
        
        //프사 이미지 둥글게
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        nickChangeTextField.layer.cornerRadius = 10
        nickChangeTextField.layer.borderWidth = 1
        nickChangeTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor

        nickOverlapBtn.layer.cornerRadius = 10
        
        nickChangeBtn.layer.cornerRadius = 10
    }
    
    
}
