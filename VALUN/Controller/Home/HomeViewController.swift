//
//  HomeViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/23.
//

import UIKit
import CoreLocation
import Alamofire
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView! {
        didSet {
            if profileImageView == nil {
                profileImageView.image = UIImage(systemName: "person.circle") ?? UIImage()
            }
        }
    }
    
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
    
    //내정보
    var myProfile = ""
    var myNick = ""
    var myID = ""
    var myBroom = 0
        
    
    //최근 이슈
    var recentIssueList: [Issue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMyProfile()
        setUI()
        setLocation()
    }
    //MARK: - OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let storyBoard = UIStoryboard(name: "MyProfile", bundle: nil)
        let profileVC = storyBoard.instantiateViewController(identifier: "MyProfileViewController") as! MyProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        profileVC.paramProfileImage = myProfile
        profileVC.paramId = myID
        profileVC.paramNick = myNick
        profileVC.paramBroom = myBroom
        
    }
    //MARK: - IBAction
    
    @IBAction func locationNowBtnPressed(_ sender: UIButton) {
        locationManger.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.addressInfo(lati: self.lat_now, longi: self.lng_now)
            self.locationManger.stopUpdatingLocation()
            self.getRecentIssue()
        }
    }
    
    @IBAction func issueReportBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueReport", bundle: nil)
        let issueReportVC = storyBoard.instantiateViewController(identifier: "IssueReportViewController") as! IssueReportViewController
        self.navigationController?.pushViewController(issueReportVC, animated: true)
        
        issueReportVC.paramlat = lat_now
        issueReportVC.paramlng = lng_now
    }
    
    @IBAction func mapShowBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Map", bundle: nil)
        let mapVC = storyBoard.instantiateViewController(identifier: "MapViewController") as! MapViewController
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
        
        //프사 이미지 둥글게
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.clipsToBounds = true
        
        //button
        makeBtnShdow(btn: issueReportBtn)
        makeBtnShdow(btn: mapShowBtn)
        makeBtnShdow(btn: communityBtn)
        makeBtnShdow(btn: environmentalInfoBtn)
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
        
    }
    
    private func makeBtnShdow(btn : UIButton) {
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 10
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.masksToBounds = false
        
    }
    
    //MARK: - Get MyProfile
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "token")!]
    private func getMyProfile() {
        AF.request(VALUNURL.myProfileURL, method: .get, headers: header)
            .validate()
            .responseDecodable(of: myProfileResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                        print(VALUNLog.debug("getMyProfile-success"))
                    
                    if response.data != nil {
                        let data = response.data?.profile
                        self.myProfile = data?.profileImage ?? ""
                        self.myID = data?.id ?? ""
                        self.myNick = data?.nick ?? ""
                        self.myBroom = data?.broom ?? 0
                        
                        let url = URL(string: data?.profileImage ?? "person.circle")
                        self.profileImageView.kf.setImage(with: url)
                        
                        self.nickNameLabel.text = data?.nick
                    }
                        


                case .failure(let error):
                    VALUNLog.error("getMyProfile - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        
                    }
                }
            }
    }
    
    //MARK: - Get RecentIssue
    private func getRecentIssue() {
        AF.request("\(VALUNURL.recentIssueURL)?lat=\(lat_now)&lng=\(lng_now)", method: .get, headers: header)
            .validate()
            .responseDecodable(of: RecentIssueResponse.self) { [weak self] response in
                guard let self = self else {return}
                switch response.result {
                case .success(let response):
                        print(VALUNLog.debug("getRecentIssue-success"))
                    
                    if response.data != nil {
                        let data = response.data?.issues
                        self.recentIssueList = data ?? []
                        
                    }
                        


                case .failure(let error):
                    VALUNLog.error("getRecentIssue - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        
                    }
                }
            }
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
