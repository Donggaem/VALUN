//
//  UnresolvedViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit
import Alamofire

class Reported_UnresolvedViewController: UIViewController {
    
    @IBOutlet var unsolvedTableView: UITableView!
    
    var unsolvedList: [Issue] = []
    
    //키 영어 -> 밸류 한글
   var categoryDictionary: Dictionary<String, String> = ["pet":"PET", "metal":"금속", "paper":"종이", "plastic":"플라스틱", "trash":"일반쓰레기", "styrofoam":"스티로폼", "glass":"유리", "garbage":"음식물 쓰레기", "waste":"폐기물", "lumber":"목재", "vinyl":"비닐", "etc":"기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMyUnsolvedIssue()
        setTableView()
    }
    //MARK: - GetUnsolvedIssue
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "token")!]
    private func getMyUnsolvedIssue() {
        AF.request(VALUNURL.myReportIssueURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: MyReportIssueResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    print(VALUNLog.debug("getMyUnsolvedIssue-success"))
                    self.unsolvedList.removeAll()
                    if response.data != nil {
                        let data = response.data
                        self.unsolvedList = data?.unsolveds ?? []
                        
                    }
                    self.unsolvedTableView.reloadData()
                    
                    
                case .failure(let error):
                    VALUNLog.error("getMyUnsolvedIssue - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        
                    }
                }
            }
    }
    
}

//MARK: - TableViewExtension
extension Reported_UnresolvedViewController: UITableViewDataSource, UITableViewDelegate{
    
    // TableView 셋팅
    private func setTableView() {
        self.unsolvedTableView.delegate = self
        self.unsolvedTableView.dataSource = self
        self.unsolvedTableView.register(UINib(nibName: "MyIssueTableViewCell", bundle: nil),  forCellReuseIdentifier: "MyIssueTableViewCell")
        
        unsolvedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블뷰 셀 선 없애기
        
    }
    
    
    //Cell 갯수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unsolvedList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssueTableViewCell", for: indexPath) as! MyIssueTableViewCell
        
        let url = URL(string: unsolvedList[indexPath.row].imageUrl)
        cell.issueImage.kf.setImage(with: url)
        cell.issueCategoryLabel.text = categoryDictionary[unsolvedList[indexPath.row].category]
        cell.issueContentLabel.text = unsolvedList[indexPath.row].description
        cell.issueStateLabel.text = "미해결"
        cell.issueStateLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        cell.issueStateView.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        cell.selectionStyle = .none
        return cell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "IssueDetail", bundle: nil)
        let issueDetailVC = storyBoard.instantiateViewController(identifier: "IssueDetailViewController") as! IssueDetailViewController
        self.navigationController?.pushViewController(issueDetailVC, animated: true)
        
        issueDetailVC.paramIssueObject.append(unsolvedList[indexPath.row])
        issueDetailVC.paramIssueDistance = ""
    }
}
