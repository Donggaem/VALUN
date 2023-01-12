//
//  Solved_CompletedViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit
import Alamofire

class Solved_CompletedViewController: UIViewController {

    @IBOutlet var solvedTableView: UITableView!
    var solvedList: [WithSolution] = []
    
    //키 영어 -> 밸류 한글
   var categoryDictionary: Dictionary<String, String> = ["pet":"PET", "metal":"금속", "paper":"종이", "plastic":"플라스틱", "trash":"일반쓰레기", "styrofoam":"스티로폼", "glass":"유리", "garbage":"음식물 쓰레기", "waste":"폐기물", "lumber":"목재", "vinyl":"비닐", "etc":"기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getMySolvedIssue_Sol()
        setTableView()
    }
    
    //MARK: - GetMySolvedIssue
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "token")!]
    private func getMySolvedIssue_Sol() {
        AF.request(VALUNURL.mySoltionIssueURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: MySolutionIssueResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                    print(VALUNLog.debug("getMySolvedIssue_Sol-success"))
                    self.solvedList.removeAll()
                    if response.data != nil {
                        let data = response.data
                        self.solvedList = data?.solveds ?? []
                        
                    }
                    self.solvedTableView.reloadData()
                    
                    
                case .failure(let error):
                    VALUNLog.error("getMySolvedIssue_Sol - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        
                    }
                }
            }
    }
    
}

//MARK: - TableViewExtension
extension Solved_CompletedViewController: UITableViewDataSource, UITableViewDelegate{
    
    // TableView 셋팅
    private func setTableView() {
        self.solvedTableView.delegate = self
        self.solvedTableView.dataSource = self
        self.solvedTableView.register(UINib(nibName: "MyIssueTableViewCell", bundle: nil),  forCellReuseIdentifier: "MyIssueTableViewCell")
        
        solvedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블뷰 셀 선 없애기
        
    }
    
    
    //Cell 갯수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solvedList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIssueTableViewCell", for: indexPath) as! MyIssueTableViewCell
        
        let url = URL(string: solvedList[indexPath.row].issue.imageUrl)
        cell.issueImage.kf.setImage(with: url)
        cell.issueCategoryLabel.text = categoryDictionary[solvedList[indexPath.row].issue.category]
        cell.issueContentLabel.text = solvedList[indexPath.row].issue.description
        cell.issueStateLabel.text = "해결완료"
        cell.issueStateLabel.textColor =  UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
        cell.issueStateView.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor
        
        cell.selectionStyle = .none
        return cell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "IssueValidation", bundle: nil)
        let issueValidationVC = storyBoard.instantiateViewController(identifier: "IssueValidationViewController") as! IssueValidationViewController
        self.navigationController?.pushViewController(issueValidationVC, animated: true)
        
        issueValidationVC.paramIssueObject.append(solvedList[indexPath.row])
    }
}
