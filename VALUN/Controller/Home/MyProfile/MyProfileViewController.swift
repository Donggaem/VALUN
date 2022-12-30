//
//  MyProfileViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/25.
//

import UIKit

class MyProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
       
    }
    
    //MARK: INNSER Func
    private func setUI() {
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
    }
}
