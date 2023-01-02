//
//  IssueResolutionViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/02.
//

import UIKit

class IssueResolutionViewController: UIViewController {

    @IBOutlet var beforeMarkView: UIView!
    @IBOutlet var beforeImage: UIImageView!
    
    
    @IBOutlet var afterMarkView: UIView!
    @IBOutlet var afterImage: UIImageView!
    
    @IBOutlet var mapSubView: UIView!
    private var mapView: MTMapView?
    
    @IBOutlet var specialNoteTextView: UITextView!
    let textViewPlaceHolder = "이슈를 해결하면서 있었던 특이사항을 적어주세요."
    
    @IBOutlet var resolutionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setTextView()
        setMap()
    }
    
    //MARK: - IBAction
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resolutionBtnPressed(_ sender: UIButton) {
        
    }
    
    //MARK: INNER Func
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
        
        resolutionBtn.layer.cornerRadius = 10
    }
}

//MARK: - Extension Map
extension IssueResolutionViewController: MTMapViewDelegate {
    
    private func setMap() {
        // 지도 불러오기
        mapView = MTMapView(frame: mapSubView.bounds)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            

            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
//            //맵 센터
//            mapView.setMapCenter( MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.44128488649227, longitude: 127.12907852966377)), zoomLevel: -2, animated: true)
            
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

//MARK: Extension TextView
extension IssueResolutionViewController: UITextViewDelegate {
    
    //텍스트뷰 바깥터치시 EndEditing함수 실행 할수있게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.specialNoteTextView.resignFirstResponder()
    }
    
    private func setTextView() {
        specialNoteTextView.delegate = self
        
        //처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        specialNoteTextView.text = textViewPlaceHolder
        specialNoteTextView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    }
    
    //텍스브뷰 닫힐시
    func textViewDidEndEditing(_ textView: UITextView) {
        if specialNoteTextView.text.isEmpty {
            specialNoteTextView.text = textViewPlaceHolder
            specialNoteTextView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        
    }
    
    //텍스트뷰 열릴시
    func textViewDidBeginEditing(_ textView: UITextView) {
        if specialNoteTextView.text == textViewPlaceHolder {
            specialNoteTextView.text = nil
            specialNoteTextView.textColor = UIColor.black
        }
    }
    
}
