//
//  IssueReportViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/25.
//

import UIKit
import AVFoundation
import Alamofire

class IssueReportViewController: UIViewController {
    
    @IBOutlet var issueReportImage: UIImageView!
    var imageData: Data = Data()
    
    @IBOutlet var cameraImgView: UIImageView!
    
    @IBOutlet var choiceBtn: UIButton!
    
    @IBOutlet var categoryView: UIView!
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var contentTextView: UITextView!
    
    
    @IBOutlet var issueReportBtn: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    let textViewPlaceHolder = "이슈에 대한 내용을 작성해 주세요."
    
    var paramlat = 0.0
    var paramlng = 0.0
    
    //키 한글 -> 밸류 영어
    var koToengDictionary: Dictionary<String, String> = ["PET":"pet,", "금속":"metal,", "종이":"paper,", "플라스틱":"plastic,", "일반쓰레기":"trash,", "스티로폼":"styrofoam,", "유리":"glass,", "음식물 쓰레기":"garbage,", "폐기물":"waste,", "목재":"lumber,", "비닐":"vinyl,", "기타":"etc,"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setImagePicker()
        setTextView()
        
//        // 카메라 권한
//        AVCaptureDevice.requestAccess(for: .video) { (result) in
//            print(result)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

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
    
    @IBAction func choiceBtnPressed(_ sender: UIButton) {
        guard let popUp = self.storyboard?.instantiateViewController(identifier: "CategoryModalViewController") as? CategoryModalViewController else {return}
//        popUp.modalPresentationStyle = .overFullScreen
        popUp.modalPresentationStyle = .fullScreen
        popUp.modalTransitionStyle = .crossDissolve
        popUp.delegate = self
        self.present(popUp, animated: true)
        
    }
    
    @IBAction func issueReportBtnPressed(_ sender: UIButton) {
        let description = contentTextView.text ?? ""
        let category = koToengDictionary[categoryLabel.text ?? ""] ?? ""
        let lat = paramlat
        let lng = paramlng
        let image = imageData
        
        let params = ReportIssueRequest(description: description, category: category, lat: lat, lng: lng, image: image)
        postReportIssue(params)
    }
    
    //MARK: - INNER Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        issueReportImage.layer.cornerRadius = 10
        issueReportImage.layer.borderWidth = 1
        issueReportImage.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        choiceBtn.layer.cornerRadius = 10
        
        categoryView.layer.cornerRadius = 10
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor(red: 0.886, green: 0.886, blue: 0.886, alpha: 1).cgColor
        
        issueReportBtn.layer.cornerRadius = 10
        
    }
    
    
    //MARK: - POST Report
    
    func postReportIssue(_ parameters: ReportIssueRequest) {
        let headers: HTTPHeaders = ["Content - type": "multipart/form-data", "authorization": UserDefaults.standard.string(forKey: "token")!]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            let description = parameters.description
            let category = parameters.category
            let lat = parameters.lat
            let lng = parameters.lng
            
            let parameters: [String: Any] = [
                "description" : description,
                "category" : category,
                "lat" : lat,
                "lng" : lng,
            ]
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            self.imageData = self.issueReportImage.image?.jpegData(compressionQuality: 0.5) ?? Data()
            print(self.imageData)
            
            
            multipartFormData.append(self.imageData, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")
            
            
            //            if let image = self.imageData {
            //                multipartFormData.append(image, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")
            //            }
            
        }, to: VALUNURL.reportIssueURL, method: .post, headers: headers).responseDecodable(of: ReportIssueResponse.self) {
            [self] response in
            switch response.result {
            case .success(let response):
                VALUNLog.debug("postReportIssue-success")
                
                let report_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
                report_alert.addAction(okAction)
                present(report_alert, animated: false, completion: nil)
                
            case .failure(let error):
                VALUNLog.error("postReportIssue - err")
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

//MARK: - Extension UIImagePicker
extension IssueReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setImagePicker() {
        imagePickerController.delegate = self
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        issueReportImage.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        issueReportImage.addGestureRecognizer(tapImageViewRecognizer)
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
            issueReportImage.image = image
            cameraImgView.isHidden = true
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
extension IssueReportViewController: UITextViewDelegate {
    
    //텍스트뷰 바깥터치시 EndEditing함수 실행 할수있게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.resignFirstResponder()
    }
    
    private func setTextView() {
        contentTextView.delegate = self
        
        //처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 만들어주기
        contentTextView.text = textViewPlaceHolder
        contentTextView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    }
    
    //텍스브뷰 닫힐시
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = textViewPlaceHolder
            contentTextView.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        
    }
    
    //텍스트뷰 열릴시
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.text == textViewPlaceHolder {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
    }
    
}

extension IssueReportViewController: DimissAction {
    func GetTitle(categoryTitle: String) {
        categoryLabel.text = categoryTitle
        categoryView.backgroundColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
        
        if categoryTitle == "" {
            categoryView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
            
    }
    

}
