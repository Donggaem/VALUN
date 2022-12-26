//
//  ViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/13.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    @IBOutlet var listBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        setUI()
    }
    
    //MARK: - Inner Func
    private func setUI() {
        self.view.bringSubviewToFront(listBtn) // 뷰를 최상위로

    }
    @IBAction func listBtnPressed(_ sender: UIButton) {
        print("클릭")
    }
    
}

//MARK: - MapExtension
extension MapViewController: MTMapViewDelegate {
    
    private func setMap() {
        // 지도 불러오기
        mapView = MTMapView(frame: subView.frame)
        
        if let mapView = mapView {
            // 델리게이트 연결
            mapView.delegate = self
            // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
            mapView.baseMapType = .standard
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            self.view.addSubview(mapView)

        }
    }
}

