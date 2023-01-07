//
//  HomeViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/23.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var profileImgBtn: UIButton!
    
    @IBOutlet var locationNowView: UIView!
    @IBOutlet var locationNowBtn: UIButton!
    @IBOutlet var locationNowLabel: UILabel!
    
    @IBOutlet var issueReportBtn: UIButton!
    @IBOutlet var mapShowBtn: UIButton!
    @IBOutlet var communityBtn: UIButton!
    @IBOutlet var environmentalInfoBtn: UIButton!
    
    //위치
    var locationManger = CLLocationManager()
    var lat_now = 0.0
    var lng_now = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLocation()
    }
    
    //MARK: - IBAction
    
    @IBAction func locationNowBtnPressed(_ sender: UIButton) {
        addressInfo(lati: lat_now, longi: lng_now)
        locationManger.stopUpdatingLocation()
        
    }
    @IBAction func profileImgBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(identifier: "MyProfileViewController")
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func issueReportBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueReport", bundle: nil)
        let issueReportVC = storyBoard.instantiateViewController(identifier: "IssueReportViewController")
        self.navigationController?.pushViewController(issueReportVC, animated: true)
    }
    
    @IBAction func mapShowBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Map", bundle: nil)
        let mapVC = storyBoard.instantiateViewController(identifier: "MapViewController")
        self.navigationController?.pushViewController(mapVC, animated: true)
        
    }
    
    @IBAction func communityBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func environmentalInfoBtnPressed(_ sender: UIButton) {
    }
    
    //MAEK: - INNER Func
    private func setUI() {
        
        //view
        topView.layer.cornerRadius = 10
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        locationNowView.layer.cornerRadius = 20
        
        //button
        makeBtnShdow(btn: issueReportBtn)
        makeBtnShdow(btn: mapShowBtn)
        makeBtnShdow(btn: communityBtn)
        makeBtnShdow(btn: environmentalInfoBtn)
        
        
    }
    
    private func makeBtnShdow(btn : UIButton) {
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 10
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.masksToBounds = false
        
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
        
        locationManger.startUpdatingLocation() //위치 정보 받아오기 시작

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
            self.locationManger.requestWhenInUseAuthorization() //권한허용 알란트
        }
    }
    
    // 위치 정보 계속 업데이트 -> 위도 경도 받아옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print("didUpdateLocations")
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
            
            lat_now = location.coordinate.latitude
            lng_now = location.coordinate.longitude
            
        }
    }
    
    // 위도 경도 받아오기 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func addressInfo(lati:CLLocationDegrees, longi:CLLocationDegrees){
        let findLocation = CLLocation(latitude: lati, longitude: longi )
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") // [나라 코드 설정]
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            
            if error != nil {
                
                print("error : \(error?.localizedDescription)")
                
            }
            else {
                if let address: [CLPlacemark] = placemarks {
                    
                    self.locationNowLabel.text = "\(address.last?.administrativeArea ?? "") \(address.last?.locality ?? "") \(address.last?.name ?? "")"
                    print("administrativeArea : \(address.last?.administrativeArea ?? "")")
                    print("locality : \(address.last?.locality ?? "")")
                    print("name : \(address.last?.name ?? "")")
                    
                    
                }
            }
            
        })
        
    }
}
