//
//  IssueResolutionViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/02.
//

import UIKit
import AVFoundation
import Alamofire

class IssueResolutionViewController: UIViewController {

    @IBOutlet var beforeMarkView: UIView!
    @IBOutlet var beforeImage: UIImageView!
    
    
    @IBOutlet var afterMarkView: UIView!
    @IBOutlet var afterImage: UIImageView!
    var imageData: Data = Data()
    
    @IBOutlet var mapSubView: UIView!
    private var mapView: MTMapView?
    
    @IBOutlet var specialNoteTextView: UITextView!
    let textViewPlaceHolder = "이슈를 해결하면서 있었던 특이사항을 적어주세요."
    
    @IBOutlet var resolutionBtn: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    var paramIsssueObject: [Issue] = []
    
    var lat_now = 0.0
    var lng_now = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setTextView()
        setMap()
        setImagePicker()
    }
    
    //MARK: - OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if self.CameraAuth() {
            self.openCamera()
        } else {
            self.AuthSettingOpen(AuthString: "카메라")
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resolutionBtnPressed(_ sender: UIButton) {
        let issueId = paramIsssueObject[0].id
        let description = specialNoteTextView.text ?? ""
        let lat = lat_now
        let lng = lng_now
        let image = imageData
        
        print("======================")
        print(issueId)
        print(description)
        print(lat)
        print(lng)
        print(image)
        print("======================")

        let params = ResolutionIssueRequest(issueId: issueId, description: description, lat: lat, lng: lng, image: image)
        
        postResolutionIssue(params)
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
        
        //받아온 데이터 처리
        let url = URL(string: paramIsssueObject[0].imageUrl)
        beforeImage.kf.setImage(with: url)
        
    }
    
    //MARK: - POSTResolutionIssue
    
    func postResolutionIssue(_ parameters: ResolutionIssueRequest) {
        let headers: HTTPHeaders = ["Content - type": "multipart/form-data", "authorization": UserDefaults.standard.string(forKey: "token")!]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            let issueId = parameters.issueId
            let description = parameters.description
            let lat = parameters.lat
            let lng = parameters.lng
            
            let parameters: [String: Any] = [
                "description" : description,
                "issueId" : issueId,
                "lat" : lat,
                "lng" : lng,
            ]
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            self.imageData = self.afterImage.image?.jpegData(compressionQuality: 0.5) ?? Data()
            
            multipartFormData.append(self.imageData, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")

            
        }, to: VALUNURL.resolutionIssueURL, method: .post, headers: headers).responseDecodable(of: ResolutionIssueResponse.self) {
            [self] response in
            switch response.result {
            case .success(let response):
                VALUNLog.debug("postResolutionIssue-success")
                
                let report_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
                report_alert.addAction(okAction)
                present(report_alert, animated: false, completion: nil)
                
            case .failure(let error):
                VALUNLog.error("postResolutionIssue - err")
                print(error.localizedDescription)
                if let statusCode = response.response?.statusCode {
                    print("에러코드 : \(statusCode)")
                    switch (statusCode) {
                    case 400..<500:
                        let reportFail_alert = UIAlertController(title: "실패", message:"입력을 확인해 주세요", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        reportFail_alert.addAction(okAction)
                        present(reportFail_alert, animated: false, completion: nil)
                    default:
                        let reportFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        reportFail_alert.addAction(okAction)
                        present(reportFail_alert, animated: false, completion: nil)
                    }
                }
            }
        }
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
            
            mapView.setZoomLevel(-2, animated: true)
            
            // 현재 위치 트래킹
            DispatchQueue.main.async {
                mapView.currentLocationTrackingMode = .onWithoutHeading
                mapView.showCurrentLocationMarker = true
            }
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
        poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: paramIsssueObject[0].lat, longitude: paramIsssueObject[0].lng))
        mapView!.addPOIItems([poiltem])

    }
    
    //현 위치 트래킹 함수
       func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
           let currentLocation = location?.mapPointGeo()
           if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
               lat_now = latitude
               lng_now = longitude

           }
       }
}
//MARK: - Extension UIImagePicker
extension IssueResolutionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setImagePicker() {
        imagePickerController.delegate = self
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        afterImage.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        afterImage.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    //카메라 띄우기
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.imagePickerController.sourceType = .camera
            present(self.imagePickerController, animated: false, completion: nil)
        }
        else {
            print ("Camera's not available as for now.")
        }
    }
    
    //이미지가 지정되었을 때 호출되는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            afterImage.image = image
            imageData = image.jpegData(compressionQuality: 0.5) ?? Data()
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
        
        //        self.imagePickerController.dismiss(animated: true)
        //
        //        // 선택된 이미지(소스)가 없을수도 있으니 옵셔널 바인딩해주고, 이미지가 선택된게 없다면 오류를 발생시킵니다.
        //        guard let userPickedImage = info[.originalImage] as? UIImage else {
        //            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        //        }
        //        cameraImgView.isHidden = true
        //        issueReportImage.image = userPickedImage
        //        print(userPickedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //카메라 접근 권한
    func CameraAuth() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.authorized
    }
    
    //세팅창 오픈
    func AuthSettingOpen(AuthString: String) {
        if let AppName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let message = "\(AppName)이(가) \(AuthString) 접근 허용되어 있지않습니다. \r\n 설정화면으로 가시겠습니까?"
            let authAlert = UIAlertController(title: "설정", message: message, preferredStyle: .alert)
            
            let cancle = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
                print("\(String(describing: UIAlertAction.title)) 클릭")
            }
            let confirm = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            authAlert.addAction(cancle)
            authAlert.addAction(confirm)
            
            self.present(authAlert, animated: true, completion: nil)
        }
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
