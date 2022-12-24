//
//  LoginViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeNav = storyBoard.instantiateViewController(identifier: "HomeNav")
        self.changeRootViewController(homeNav)
    }
}
