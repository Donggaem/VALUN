//
//  LoginViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/20.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTextField()
    }
    
    //MARK: - IBAction
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let id = idTextField.text ?? ""
        let pw = pwTextField.text ?? ""
        
        let param = LoginRequest(id: id, pw: pw)
        postLogin(param)
        
    }
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Signup", bundle: nil)
        let signupVC = storyBoard.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    //MARK: - INNER Func
    private func setUI() {
        
        loginBtn.layer.cornerRadius = 10
        
    }
    
    //MARK: - POST Login
    private func postLogin(_ parameters: LoginRequest){
        
        AF.request(VALUNURL.loginURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
//            .validate(statusCode: 200..<300)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    VALUNLog.debug("PostLogin - Success")
                    if response.data != nil {
                        UserDefaults.standard.set(response.data?.accessToken, forKey: "token")
                        print("토큰 값 \(response.data?.accessToken)")
                    }
                    
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
                    self.changeRootViewController(homeNav)
                    
                case .failure(let error):
                    VALUNLog.error("PostLogin - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        switch (statusCode) {
                            case 400..<500:
                            let loginFail_alert = UIAlertController(title: "실패", message:"아이디와 비밀번호를 확인해 주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            loginFail_alert.addAction(okAction)
                            present(loginFail_alert, animated: false, completion: nil)
                        default:
                            let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            loginFail_alert.addAction(okAction)
                            present(loginFail_alert, animated: false, completion: nil)
                        }
                    }
                }
            }
    }
}

//MARK: - UITextField
extension LoginViewController: UITextFieldDelegate {
    
    private func setTextField() {
        self.idTextField.delegate = self
        self.pwTextField.delegate = self
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
    }
    
    //MARK: - OBJC
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        //2개 텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인.
        if !(self.idTextField.text?.isEmpty ?? true) && !(self.pwTextField.text?.isEmpty ?? true) {
            loginBtn(willActive: true)
        }
        else {
            
            loginBtn(willActive: false)
        }
        
    }
    
    //MARK: - INNER FUNC
    //버튼 활성화/비활성화
    func loginBtn(willActive: Bool) {
        
        if(willActive == true) {
            
            loginBtn.setTrue()
        } else {
            loginBtn.setFalse()
        }
    }
    
   
}
