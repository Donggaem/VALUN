//
//  IssueDetailViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/28.
//

import UIKit

class IssueDetailViewController: UIViewController {

    @IBOutlet var optionBtn: UIButton!
    
    @IBOutlet var issueImage: UIImageView!
    @IBOutlet var bitgaruLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var outstandingBtn: UIButton!
    @IBOutlet var resolvingBtn: UIButton!
    @IBOutlet var resolvedBtn: UIButton!
    @IBOutlet var destanceLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var issueDateLabel: UILabel!
    
    @IBOutlet var mapSubView: UIView!
    private var mapView: MTMapView?
    @IBOutlet var chatBtn: UIButton!
    @IBOutlet var issueResolveBtn: UIButton!
    
    @IBOutlet var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        setMap() // 뷰가 이상하게 나옴
    }

    //MARK: - INNER Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.bringSubviewToFront(bottomView)

        
        //Button UI조정
        //미해결
        outstandingBtn.layer.cornerRadius = 12
        outstandingBtn.layer.borderWidth = 1
        outstandingBtn.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        //해결중
        resolvingBtn.layer.cornerRadius = 12
        resolvingBtn.layer.borderWidth = 1
        resolvingBtn.layer.borderColor = UIColor(red: 0.929, green: 0.424, blue: 0.404, alpha: 1).cgColor
        
        //해결완료
        resolvedBtn.layer.cornerRadius = 12
        resolvedBtn.layer.borderWidth = 1
        resolvedBtn.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor
        
        //채팅
        chatBtn.layer.cornerRadius = 10
        chatBtn.layer.borderWidth = 1
        chatBtn.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        
        //해결완료
        issueResolveBtn.layer.cornerRadius = 10


    }
    
    //MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func optionBtnPressed(_ sender: UIButton) {
    }
    @IBAction func chatBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func issueResolveBtnPressed(_ sender: UIButton) {
    }
}

//MARK: - MapExtension
extension IssueDetailViewController: MTMapViewDelegate {
    
    private func setMap() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            self.view.addSubview(mapView)
            setPin()
        }
    }
    
    func setPin() {
        let poiltem = MTMapPOIItem()
        poiltem.itemName = "test"
        poiltem.markerType = .redPin
        poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.44128488649227, longitude: 127.12907852966377))
        mapView!.addPOIItems([poiltem])

    }
}
