//
//  HomeViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/23.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    //위치
    var locationManger = CLLocationManager()
    var lat_now = 0.0
    var lng_now = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLocation()
    }
    
    //MARK: - IBAction
    @IBAction func issueReportBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueReport", bundle: nil)
        let issueReportVC = storyBoard.instantiateViewController(identifier: "IssueReportViewController")
        self.navigationController?.pushViewController(issueReportVC, animated: true)
    }
    
    @IBAction func mapBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Map", bundle: nil)
        let mapVC = storyBoard.instantiateViewController(identifier: "MapViewController")
        self.navigationController?.pushViewController(mapVC, animated: true)

    }
    
}

//MARK: - Location Extension
extension HomeViewController: CLLocationManagerDelegate {
    
    //위치 set함수
    private func setLocation() {
        // 델리게이트 설정
        locationManger.delegate = self
        // 거리 정확도 설정
        locationManger.desiredAccuracy = kCLLocationAccuracyBest

    }
    
    //위치권한 설정
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            print("GPS 권한이 설정됨")
            locationManger.startUpdatingLocation() //위치 정보 받아오기 시작
        case .restricted,.notDetermined:
            print("GPS 권한이 설정되지않음")
            self.locationManger.requestWhenInUseAuthorization() //권한허용 알란트
        case .denied:
            print("GPS 권한이 요청 거부됨")
            self.locationManger.requestWhenInUseAuthorization() //권한허용 알란트
        default:
            print("GPS: Default")
        }
    }
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations")
        if let location = locations.first {
//            print("위도: \(location.coordinate.latitude)")
//            print("경도: \(location.coordinate.longitude)")
            
            lat_now = location.coordinate.latitude
            lng_now = location.coordinate.longitude
            
        }
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
