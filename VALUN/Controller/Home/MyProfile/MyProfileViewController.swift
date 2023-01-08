//
//  MyProfileViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/25.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet var myProfileImage: UIImageView!
    @IBOutlet var myNickLabel: UILabel!
    @IBOutlet var myBroomLabel: UILabel!
    
    var paramProfileImage = ""
    var paramNick = ""
    var paramId = ""
    var paramBroom = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
       
    }
    
    @IBAction func profileNickChangeBtnPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "MyProfile", bundle: nil)
        let popUp = storyboard.instantiateViewController(identifier: "ProfileNickChangeModalViewController")
        popUp.modalPresentationStyle = .overFullScreen
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
        
    }
    
    @IBAction func pwChangeBtnPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "MyProfile", bundle: nil)
        let popUp = storyboard.instantiateViewController(identifier: "PwChangeModalViewController")
        popUp.modalPresentationStyle = .overFullScreen
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
        
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
        
        //프사 이미지 둥글게
        myProfileImage.layer.cornerRadius = myProfileImage.bounds.height/2
        myProfileImage.clipsToBounds = true
        
        //받아온 정보 세팅
        //서버에서 받아온 내정보 입력
        let url = URL(string: paramProfileImage)
        myProfileImage.kf.setImage(with: url)
        myNickLabel.text = paramNick
        myBroomLabel.text = String(paramBroom)
    }
}
