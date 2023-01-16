//
//  IssueValidationViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/02.
//

import UIKit

class IssueValidationViewController: UIViewController {

    @IBOutlet var beforeMarkView: UIView!
    @IBOutlet var beforeImage: UIImageView!
    
    @IBOutlet var afterMarkView: UIView!
    @IBOutlet var afterImage: UIImageView!
    
    @IBOutlet var mapSubView: UIView!
    private var mapView: MTMapView?

    @IBOutlet var specialNoteTextView: UITextView!
    
    @IBOutlet var refusalBtn: UIButton!
    @IBOutlet var acceptBtn: UIButton!
    
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
        
        //넘어온데이터 처리
        let beforeurl = URL(string: paramIssueObject[0].issue.imageUrl)
        beforeImage.kf.setImage(with: beforeurl)
        
        let afterurl = URL(string: paramIssueObject[0].solution.imageUrl)
        afterImage.kf.setImage(with: afterurl)
        
        specialNoteTextView.text = paramIssueObject[0].solution.description
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
