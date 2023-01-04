//
//  AllIssueViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit

class Reported_AllIssueViewController: UIViewController {

    @IBOutlet var allIssueTableView: UITableView!
    
    var tabletest1: [String] = ["test1", "test2", "test3"]
    var tabletest2: [String] = ["test1", "test2", "test3"]
    var tabletest3: [String] = ["미해결", "해결중", "해결완료"]
    var tabletestImg: [String] = ["common1", "common2", "common3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }
    
}

//MARK: - TableViewExtension
extension Reported_AllIssueViewController: UITableViewDataSource, UITableViewDelegate{
   
    
    // TableView 셋팅
    private func setTableView() {
        self.allIssueTableView.delegate = self
        self.allIssueTableView.dataSource = self
        self.allIssueTableView.register(UINib(nibName: "MyIssueTableViewCell", bundle: nil),  forCellReuseIdentifier: "MyIssueTableViewCell")
        
        allIssueTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블뷰 셀 선 없애기

    }
    
    
    //Cell 갯수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabletest1.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssueTableViewCell", for: indexPath) as! MyIssueTableViewCell
        
        cell.issueCategoryLabel.text = tabletest1[indexPath.row]
        cell.issueContentLabel.text = tabletest2[indexPath.row]
        cell.issueImage.image = UIImage(named: tabletestImg[indexPath.row])
        cell.issueStateLabel.text = tabletest3[indexPath.row]
        
        if cell.issueStateLabel.text == "미해결" {
            
            cell.issueStateLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            cell.issueStateView.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
            
        } else if cell.issueStateLabel.text == "해결중" {
            
            cell.issueStateLabel.textColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1)
            cell.issueStateView.layer.borderColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1).cgColor
            

        }else if cell.issueStateLabel.text == "해결완료" {
            
            cell.issueStateLabel.textColor =  UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
            cell.issueStateView.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor
            

        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
