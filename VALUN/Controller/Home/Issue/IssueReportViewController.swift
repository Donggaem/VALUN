//
//  IssueReportViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/25.
//

import UIKit

class IssueReportViewController: UIViewController {
    
    @IBOutlet var issueReportImage: UIImageView!
    @IBOutlet var cameraImgView: UIImageView!
    
    @IBOutlet var choiceBtn: UIButton!
    @IBOutlet var categoryBtn: UIButton!
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var placeholder: UILabel!
    
    
    @IBOutlet var issueReportBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    //MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func choiceBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func issueReportBtnPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - INNER Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        issueReportImage.layer.cornerRadius = 10
        issueReportImage.layer.borderWidth = 1
        issueReportImage.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        choiceBtn.layer.cornerRadius = 10
        
        categoryBtn.layer.cornerRadius = 10
        categoryBtn.isEnabled = false
        categoryBtn.isHidden = true // 선택전
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor(red: 0.886, green: 0.886, blue: 0.886, alpha: 1).cgColor
        
        issueReportBtn.layer.cornerRadius = 10
    }
}
