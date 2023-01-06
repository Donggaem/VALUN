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
        let signupVC = storyBoard.instantiateViewController(identifier: "SignupViewController")
        self.navigationController?.pushViewController(signupVC, animated: true)
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
