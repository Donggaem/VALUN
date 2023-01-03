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
            mapView.setMapCenter( MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.44128488649227, longitude: 127.12907852966377)), zoomLevel: -2, animated: true)
            
            mapView.isUserInteractionEnabled = false
            
            mapSubView.addSubview(mapView)
            
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
