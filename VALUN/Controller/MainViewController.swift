//
//  ViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/13.
//

import UIKit

class MainViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            // 지도의 센터를 설정 (x와 y 좌표, 줌 레벨 등을 설정)
            mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.456518177069526, longitude: 126.70531256589555)), zoomLevel: 5, animated: true)
            self.view.addSubview(mapView)
        }    }
    
    
}

