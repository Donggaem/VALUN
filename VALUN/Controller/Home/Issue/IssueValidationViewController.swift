//
//  IssueValidationViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/02.
//

import UIKit
import Alamofire

class IssueValidationViewController: UIViewController {
    @IBOutlet var naviTitleLabel: UILabel!
    
    @IBOutlet var beforeMarkView: UIView!
    @IBOutlet var beforeImage: UIImageView!
    
    @IBOutlet var afterMarkView: UIView!
    @IBOutlet var afterImage: UIImageView!
    
    @IBOutlet var mapSubView: UIView!
    private var mapView: MTMapView?
    
    @IBOutlet var specialNoteTextView: UITextView!
    
    @IBOutlet var refusalBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!
    
    @IBOutlet var completedBtn: UIButton!
    var paramIssueObject: [WithSolution] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setMap()
    }
    
    //MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func refusalBtnBtnPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "IssueValidation", bundle: nil)
        let popUp = storyboard.instantiateViewController(identifier: "RejectedModalViewController")
        popUp.modalPresentationStyle = .overFullScreen
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
    }
    @IBAction func acceptBtnPressed(_ sender: UIButton) {
        let id = paramIssueObject[0].solution.id
        let params = AcceptIssueRequest(id: id)
        postAccept(params)
    }
    
    //MARK: - INNER Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        beforeMarkView.layer.cornerRadius = 10
        beforeMarkView.layer.maskedCorners = .layerMaxXMinYCorner
        
        afterMarkView.layer.cornerRadius = 10
        afterMarkView.layer.maskedCorners = .layerMaxXMinYCorner
        
        specialNoteTextView.layer.cornerRadius = 5
        specialNoteTextView.layer.borderWidth = 1
        specialNoteTextView.layer.borderColor = UIColor(red: 0.886, green: 0.886, blue: 0.886, alpha: 1).cgColor
        specialNoteTextView.isEditable = false
        
        refusalBtn.layer.cornerRadius = 10
        acceptBtn.layer.cornerRadius = 10
        
        completedBtn.layer.cornerRadius = 10
        completedBtn.isHidden = true
        completedBtn.isEnabled = false
        
        if paramIssueObject[0].issue.status == "SOLVED" {
            if paramIssueObject[0].issue.isMine == true {
                completedBtn.isHidden = false
                refusalBtn.isHidden = true
                acceptBtn.isHidden = true
                naviTitleLabel.text = "해결된 이슈"
                
            }else if paramIssueObject[0].solution.isMine == true{
                completedBtn.isHidden = false
                refusalBtn.isHidden = true
                acceptBtn.isHidden = true
                naviTitleLabel.text = "해결한 이슈"

            }
        } else if paramIssueObject[0].issue.status == "PENDING" {
            if paramIssueObject[0].solution.isMine == true {
                completedBtn.isHidden = false
                completedBtn.setTitle("해결 검증중", for: .normal)
                refusalBtn.isHidden = true
                acceptBtn.isHidden = true
                naviTitleLabel.text = "검증중인 이슈"

            }
        }
        
        
        
        //넘어온데이터 처리
        let beforeurl = URL(string: paramIssueObject[0].issue.imageUrl)
        beforeImage.kf.setImage(with: beforeurl)
        
        let afterurl = URL(string: paramIssueObject[0].solution.imageUrl)
        afterImage.kf.setImage(with: afterurl)
        
        specialNoteTextView.text = paramIssueObject[0].solution.description
    }
    
    //MARK: - POST Accept
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "token")!]
    private func postAccept(_ parameters: AcceptIssueRequest){
        
        AF.request(VALUNURL.acceptIssueURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: header)
//            .validate(statusCode: 200..<300)
            .validate()
            .responseDecodable(of: AcceptIssueResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    VALUNLog.debug("postAccept - Success")
                    let accept_alert = UIAlertController(title: "성공", message: "검증을 완료하였습니다", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    accept_alert.addAction(okAction)
                    present(accept_alert, animated: false, completion: nil)
                    
                case .failure(let error):
                    VALUNLog.error("postAccept - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        switch (statusCode) {
                            case 400..<500:
                            let acceptFail_alert = UIAlertController(title: "실패", message:"입력을 확인해 주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            acceptFail_alert.addAction(okAction)
                            present(acceptFail_alert, animated: false, completion: nil)
                        default:
                            let acceptFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            acceptFail_alert.addAction(okAction)
                            present(acceptFail_alert, animated: false, completion: nil)
                        }
                    }
                }
            }
    }
    
}

//MARK: - Extension Map
extension IssueValidationViewController: MTMapViewDelegate {
    
    private func setMap() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.bounds)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            //맵 센터
            mapView.setMapCenter( MTMapPoint(geoCoord: MTMapPointGeo(latitude: paramIssueObject[0].issue.lat, longitude: paramIssueObject[0].issue.lng)), zoomLevel: -2, animated: true)
            
            //            mapView.isUserInteractionEnabled = false
            
            mapSubView.addSubview(mapView)
            
            
        }
        setPin()
    }
    
    func setPin() {
        let beforepoiltem = MTMapPOIItem()
        beforepoiltem.itemName = "before"
        beforepoiltem.markerType = .customImage
        beforepoiltem.customImageName = "question"
        beforepoiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: paramIssueObject[0].issue.lat, longitude: paramIssueObject[0].issue.lng))
        mapView!.addPOIItems([beforepoiltem])
        
        let afterpoiltem = MTMapPOIItem()
        afterpoiltem.itemName = "after"
        afterpoiltem.markerType = .customImage
        afterpoiltem.customImageName = "exclamation"
        afterpoiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: paramIssueObject[0].solution.lat, longitude: paramIssueObject[0].solution.lng))
        mapView!.addPOIItems([afterpoiltem])
        
    }
    
}
