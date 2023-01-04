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
    
    @IBAction func profileNickChangeBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func pwChangeBtnPressed(_ sender: UIButton) {
    }
    @IBAction func reportIssueBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "I_Reported_Issue", bundle: nil)
        let reportIssueVC = storyBoard.instantiateViewController(identifier: "I_Reported_IssueViewController")
        self.navigationController?.pushViewController(reportIssueVC, animated: true)
    }
    @IBAction func solveIssueBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "I_Solved_Issue", bundle: nil)
        let solveIssueVC = storyBoard.instantiateViewController(identifier: "I_Solved_IssueViewController")
        self.navigationController?.pushViewController(solveIssueVC, animated: true)
    }
    @IBAction func myCommentsBtnPressed(_ sender: UIButton) {
    }
    @IBAction func myPostBtnPressed(_ sender: UIButton) {
    }

    @IBAction func comunity_myCommentsBtnPressed(_ sender: UIButton) {
    }
    
    //MARK: INNSER Func
    private func setUI() {
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
    }
}
