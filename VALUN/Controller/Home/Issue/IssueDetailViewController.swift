//
//  IssueDetailViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/28.
//

import UIKit
import DropDown

class IssueDetailViewController: UIViewController {
    
    @IBOutlet var optionBtn: UIButton!
    
    @IBOutlet var issueImage: UIImageView!
    
    @IBOutlet var bitgaruLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var distanceImg: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var issueDateLabel: UILabel!
    
    @IBOutlet var mapSubView: UIView!
    private var mapView: MTMapView?
    @IBOutlet var chatBtn: UIButton!
    @IBOutlet var issueResolveBtn: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    let dropDown = DropDown()
    
    var paramIssueObject: [Issue] = []
    var paramIssueDistance = ""
    
    //키 영어 -> 밸류 한글
    var categoryDictionary: Dictionary<String, String> = ["pet":"PET", "metal":"금속", "paper":"종이", "plastic":"플라스틱", "trash":"일반쓰레기", "styrofoam":"스티로폼", "glass":"유리", "garbage":"음식물 쓰레기", "waste":"폐기물", "lumber":"목재", "vinyl":"비닐", "etc":"기타"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    //MARK: - INNER Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        //status(이슈상태)
        statusView.layer.cornerRadius = 12
        
        
        //채팅
        chatBtn.layer.cornerRadius = 10
        chatBtn.layer.borderWidth = 1
        chatBtn.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        
        //해결완료
        issueResolveBtn.layer.cornerRadius = 10
        
        //넘어온 데이터 처리
        let url = URL(string: paramIssueObject[0].imageUrl)
        issueImage.kf.setImage(with: url)
        categoryLabel.text = categoryDictionary[paramIssueObject[0].category]
        statusLabel.text = paramIssueObject[0].status
        contentLabel.text = paramIssueObject[0].description
        distanceLabel.text = paramIssueDistance
        
        if distanceLabel.text == "" {
            distanceImg.isHidden = true
        }else {
            distanceImg.isHidden = false
        }
        
        //시간 변경 utc -> kst
        let time = utcToLocale(utcDate: paramIssueObject[0].createdAt, dateFormat: "yyyy. MM. dd")
        issueDateLabel.text = time
        
        //이슈상태 변환
        if statusLabel.text == "UNSOLVED" {
            statusLabel.text = "미해결"
            statusView.backgroundColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1)
        }else if statusLabel.text == "PENDING" {
            statusLabel.text = "해결중"
            statusView.backgroundColor = UIColor(red: 0.462, green: 0.672, blue: 0.988, alpha: 1)
        }else if statusLabel.text == "SOLVED" {
            statusLabel.text = "해결완료"
            statusView.backgroundColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
        }else if statusLabel.text == "REPORTED" {
            statusLabel.text = "신고됨"
            statusView.backgroundColor = UIColor(red: 0.486, green: 0.416, blue: 0.769, alpha: 1)
        }
    }
    
    private func setDropDown() {
        
        dropDown.dataSource = ["수정", "삭제"]
        dropDown.show()
        dropDown.textColor = UIColor.gray
        dropDown.selectedTextColor = UIColor.black
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.anchorView = optionBtn
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height) ?? 35.0)
        dropDown.textFont = UIFont(name: "Pretendard-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        dropDown.width = 100
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            
            if item == "수정" {
                
                
            }else {
                
                
            }
        }
    }
    
    public func utcToLocale(utcDate : String, dateFormat: String) -> String
    {
        let inputDate = utcDate.split(separator: "T").map{String($0)}[0]
        
        let dfFormat = DateFormatter()
        //dfFormat.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
        dfFormat.dateFormat = "yyyy-MM-dd"
        print("🔥[DEBUG] \(inputDate)")
        dfFormat.locale = Locale(identifier: "ko-KR")
        dfFormat.timeZone = TimeZone(abbreviation: "UTC")
        let dtUtcDate = dfFormat.date(from: inputDate)
        
        print("🔥[DEBUG] \(dtUtcDate)")
        dfFormat.timeZone = TimeZone(abbreviation: "KST")
        dfFormat.dateFormat = dateFormat
        print("🔥[DEBUG] \(dtUtcDate)")
        return dfFormat.string(from: dtUtcDate ?? Date())
        
//        dfFormat.timeZone = TimeZone.current
//        dfFormat.dateFormat = dateFormat
//        return dfFormat.string(from: dtUtcDate!)
    }
    
    //MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func optionBtnPressed(_ sender: UIButton) {
        setDropDown()
    }
    @IBAction func chatBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func issueResolveBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueResolution", bundle: nil)
        let issueResolutionVC = storyBoard.instantiateViewController(identifier: "IssueResolutionViewController") as! IssueResolutionViewController
        self.navigationController?.pushViewController(issueResolutionVC, animated: true)
        
        issueResolutionVC.paramIsssueObject = paramIssueObject
    }
}

//MARK: - MapExtension
extension IssueDetailViewController: MTMapViewDelegate {
    
    private func setMap() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.bounds)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            //맵 센터
            mapView.setMapCenter( MTMapPoint(geoCoord: MTMapPointGeo(latitude: paramIssueObject[0].lat, longitude: paramIssueObject[0].lng)), zoomLevel: -2, animated: true)
            
            mapView.isUserInteractionEnabled = false
            
            mapSubView.addSubview(mapView)
            
            setPin()
        }
    }
    
    func setPin() {
        let poiltem = MTMapPOIItem()
        poiltem.itemName = "test"
        poiltem.markerType = .redPin
        poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: paramIssueObject[0].lat, longitude: paramIssueObject[0].lng))
        mapView!.addPOIItems([poiltem])
        
    }
}
