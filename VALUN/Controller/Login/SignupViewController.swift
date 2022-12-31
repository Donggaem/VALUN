//
//  SignupViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/31.
//

import UIKit

class SignupViewController: UIViewController {

    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var idOverlapBtn: UIButton!
    @IBOutlet var idMsgLabel: UILabel!
    
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var pwMsgLabel: UILabel!
    
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwCheckMsgLabel: UILabel!
    
    @IBOutlet var nickTextField: UITextField!
    @IBOutlet var nickOverlapBtn: UIButton!
    @IBOutlet var nickMsgLabel: UILabel!
    
    @IBOutlet var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTextField()
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func idOverlapBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func nickOverlapBtnPressed(_ sender: UIButton) {
        
    }
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
    }
    
    private func setUI(){
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        //프사 이미지 둥글게
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        idTextField.layer.cornerRadius = 10
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        idOverlapBtn.layer.cornerRadius = 10
        
        pwTextField.layer.cornerRadius = 10
        pwTextField.layer.borderWidth = 1
        pwTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        pwCheckTextField.layer.cornerRadius = 10
        pwCheckTextField.layer.borderWidth = 1
        pwCheckTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        nickTextField.layer.cornerRadius = 10
        nickTextField.layer.borderWidth = 1
        nickTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        nickOverlapBtn.layer.cornerRadius = 10

    }
}

//MARK: - Extension UITextField
extension SignupViewController: UITextFieldDelegate {
    
    private func setTextField() {
        
        self.idTextField.delegate = self
        self.pwTextField.delegate = self
        self.pwCheckTextField.delegate = self
        self.nickTextField.delegate = self

        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwCheckTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.nickTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
        //버튼 활성/비활성 액션
        self.idTextField.addAction(UIAction(handler: { _ in
            if self.idTextField.text?.isEmpty == true {
                self.idOverlapBtn.isEnabled = false
            } else {
                self.idOverlapBtn.isEnabled = true

            }
        }), for: .editingChanged)
        
        self.nickTextField.addAction(UIAction(handler: { _ in
            if self.nickTextField.text?.isEmpty == true {
                self.nickOverlapBtn.isEnabled = false
            } else {
                self.nickOverlapBtn.isEnabled = true
                
            }
        }), for: .editingChanged)
    
    }
    
    //닉네임 형식 확인
    private func isValidNick(testStr: String) -> Bool {
        let nickRegEx = "[가-힣A-Za-z0-9]{2,15}"
        let nickTest = NSPredicate(format:"SELF MATCHES %@", nickRegEx)
        return nickTest.evaluate(with: testStr)
    }
    
    //아이디 형식 확인
    private func isValidID(testStr: String) -> Bool {
        let idRegEx = "[A-Za-z0-9]{5,15}"
        let idTest = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: testStr)
    }
    
    //비밀번호 형식 확인
    private func isValidPW(testStr: String) -> Bool {
        let pwRegEx = "[A-Za-z0-9!_@$%^&+=]{6,15}"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return pwTest.evaluate(with: testStr)
    }
    
    private func isSameBothTextField(_ first: UITextField,_ second: UITextField) -> Bool {
        
        if(first.text == second.text) {
            
            return true
        } else {
            
            return false
        }
    }
    
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
                
        if self.pwTextField.text?.isEmpty == true{
            pwMsgLabel.text = "한/영 특수문자 제외, 10자이내"
            pwMsgLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            pwMsgLabel.font = UIFont(name: "SUIT-Bold", size: 12)
        }else if self.pwCheckTextField.text?.isEmpty == true {
            pwCheckMsgLabel.text = "한/영 특수문자 제외, 10자이내"
            pwCheckMsgLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            pwCheckMsgLabel.font = UIFont(name: "SUIT-Bold", size: 12)
        }else if isSameBothTextField(pwTextField, pwCheckTextField) == true {
            pwCheckMsgLabel.text = "비밀번호가 일치합니다"
            pwCheckMsgLabel.textColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
            pwCheckMsgLabel.font = UIFont(name: "SUIT-Bold", size: 12)
        }else {
            pwCheckMsgLabel.text = "비밀번호가 일치하지않습니다"
            pwCheckMsgLabel.textColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1)
            pwCheckMsgLabel.font = UIFont(name: "SUIT-Bold", size: 12)
        }
        
        
        //텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인, 필수 약관을 동의 했는지
        if  !(self.pwTextField.text?.isEmpty ?? true) && !(self.pwCheckTextField.text?.isEmpty ?? true) &&  !(self.idTextField.text?.isEmpty ?? true) && !(self.nickTextField.text?.isEmpty ?? true) && isSameBothTextField(pwTextField, pwCheckTextField) {
            signupBtn.isEnabled = true
        }
        else {
            signupBtn.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pwTextField {
            if isValidPW(testStr: pwTextField.text ?? "") == false {
                pwMsgLabel.text = "비밀번호 형식이 잘못되었습니다"
                let fail_alert = UIAlertController(title: "실패", message: "비밀번호 형식이 잘못되었습니다\n 한글, 영어 대소문자,숫자, !_@$%^&+= 사용 6~15자 이내", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
            }
        }
    }
}
