//
//  I_Solved_IssueViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit

class I_Solved_IssueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func optionBtnPressed(_ sender: UIButton) {
    }
}
