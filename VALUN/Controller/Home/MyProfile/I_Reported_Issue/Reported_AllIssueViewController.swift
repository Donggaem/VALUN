//
//  AllIssueViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit
import Alamofire

class Reported_AllIssueViewController: UIViewController {
    
    @IBOutlet var allIssueTableView: UITableView!
    
    var unsolvedsList: [Issue] = []
    var pendingsList: [WithSolution] = []
    var solvedsList: [WithSolution] = []
    
    var allIssueList: [Issue] = []
    
    //키 영어 -> 밸류 한글
   var categoryDictionary: Dictionary<String, String> = ["pet":"PET", "metal":"금속", "paper":"종이", "plastic":"플라스틱", "trash":"일반쓰레기", "styrofoam":"스티로폼", "glass":"유리", "garbage":"음식물 쓰레기", "waste":"폐기물", "lumber":"목재", "vinyl":"비닐", "etc":"기타"]
    
    var statusDictionary: Dictionary<String, String> = ["UNSOLVED":"미해결", "PENDING":"해결중", "SOLVED":"해결완료", "REPORTED":"신고됨"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMyAllIssue()
        setTableView()
    }
    
    //MARK: - GetMyAllIssue
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "token")!]
    private func getMyAllIssue() {
        AF.request(VALUNURL.myReportIssueURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: MyReportIssueResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    print(VALUNLog.debug("getMyAllIssue-success"))
                    self.allIssueList.removeAll()
                    self.unsolvedsList.removeAll()
                    self.pendingsList.removeAll()
                    self.solvedsList.removeAll()
                    var sortList: [Issue] = []
                    if response.data != nil {
                        let data = response.data
                        self.unsolvedsList = data?.unsolveds ?? []
                        self.pendingsList = data?.pendings ?? []
                        self.solvedsList = data?.solveds ?? []
                        
                        for index in 0..<self.unsolvedsList.endIndex {
                            sortList.append( self.unsolvedsList[index])
                        }
                        
                        for index in 0..<self.pendingsList.endIndex {
                            sortList.append( self.pendingsList[index].issue)
                        }
                        
                        for index in 0..<self.solvedsList.endIndex {
                            sortList.append( self.solvedsList[index].issue)
                        }
                        
                    }
                    self.allIssueList = sortList.sorted(by: {$0.id < $1.id })
                    self.allIssueTableView.reloadData()
                    
                case .failure(let error):
                    VALUNLog.error("getMyAllIssue - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        
                    }
                }
            }
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
        return allIssueList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssueTableViewCell", for: indexPath) as! MyIssueTableViewCell
        
        let url = URL(string: allIssueList[indexPath.row].imageUrl)
        cell.issueImage.kf.setImage(with: url)
        cell.issueCategoryLabel.text = categoryDictionary[allIssueList[indexPath.row].category]
        cell.issueContentLabel.text = allIssueList[indexPath.row].description
        cell.issueStateLabel.text = statusDictionary[allIssueList[indexPath.row].status]
        
        cell.status = statusDictionary[allIssueList[indexPath.row].status] ?? ""
        
        cell.selectionStyle = .none
        return cell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 클릭된 셀을 가져옴
        let cell = tableView.cellForRow(at: indexPath) as! MyIssueTableViewCell
        
        if cell.issueStateLabel.text == "미해결" {
            let storyBoard = UIStoryboard(name: "IssueDetail", bundle: nil)
            let issueDetailVC = storyBoard.instantiateViewController(identifier: "IssueDetailViewController") as! IssueDetailViewController
            self.navigationController?.pushViewController(issueDetailVC, animated: true)
            
            issueDetailVC.paramIssueObject.append(allIssueList[indexPath.row])
            issueDetailVC.paramIssueDistance = ""
            
        }else if cell.issueStateLabel.text == "해결중" {
            for index in 0..<pendingsList.endIndex {
                if pendingsList[index].issue.id == allIssueList[indexPath.row].id {
                    let storyBoard = UIStoryboard(name: "IssueValidation", bundle: nil)
                    let issueValidationVC = storyBoard.instantiateViewController(identifier: "IssueValidationViewController") as! IssueValidationViewController
                    self.navigationController?.pushViewController(issueValidationVC, animated: true)
                    
                    issueValidationVC.paramIssueObject.append(pendingsList[index])
                }
            }
            
            
        }else if cell.issueStateLabel.text == "해결완료" {
            for index in 0..<solvedsList.endIndex {
                if solvedsList[index].issue.id == allIssueList[indexPath.row].id {
                    let storyBoard = UIStoryboard(name: "IssueValidation", bundle: nil)
                    let issueValidationVC = storyBoard.instantiateViewController(identifier: "IssueValidationViewController") as! IssueValidationViewController
                    self.navigationController?.pushViewController(issueValidationVC, animated: true)
                    
                    issueValidationVC.paramIssueObject.append(solvedsList[indexPath.row])
                }
            }
        }else if cell.issueStateLabel.text == "신고됨" {
            
        }
        
    }
}
