//
//  SignupViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/31.
//

import UIKit
import AVFoundation
import Photos
import Alamofire

class SignupViewController: UIViewController {
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var idOverlapBtn: UIButton!
    @IBOutlet var idMsgLabel: UILabel!
    
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var pwMsgLabel: UILabel!
    
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwCheckMsgLabel: UILabel!
    
    @IBOutlet var nickTextField: UITextField!
    @IBOutlet var nickOverlapBtn: UIButton!
    @IBOutlet var nickMsgLabel: UILabel!
    
    @IBOutlet var signupBtn: UIButton!
    
    let imagePickerController = UIImagePickerController()
    let alertController = UIAlertController(title: "프로필 사진을 선택하세요", message: "기본이미지 또는 앨범에서 선택", preferredStyle: .actionSheet)
    
    var imageData: Data? = nil
    var baseImageData: Data = UIImage(systemName: "person.circle")!.jpegData(compressionQuality: 0.5)!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        enrollAlertEvent()
        setImagePicker()
        setTextField()
    }
    
    //MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func idOverlapBtnPressed(_ sender: UIButton) {
        
        let id = idTextField.text ?? ""
        let params = OverlapIdRequest(id: id)
        postOverlapId(params)
    }
    @IBAction func nickOverlapBtnPressed(_ sender: UIButton) {
        
        let nick = idTextField.text ?? ""
        let params = OverlapNickRequest(nick: nick)
        postOverlapNick(params)
    }
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        let id = self.idTextField.text ?? ""
        let pw = self.pwTextField.text ?? ""
        let nick = self.nickTextField.text ?? ""
        let image = imageData ?? baseImageData
        
        let params = SignupRequest(id: id, pw: pw, nick: nick, image: image)
        postSignup(params)
    }
    
    //MARK: - OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - INNER Func
    private func setUI(){
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        //프사 이미지 둥글게
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        idTextField.layer.cornerRadius = 10
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        idOverlapBtn.layer.cornerRadius = 10
        
        pwTextField.layer.cornerRadius = 10
        pwTextField.layer.borderWidth = 1
        pwTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        pwCheckTextField.layer.cornerRadius = 10
        pwCheckTextField.layer.borderWidth = 1
        pwCheckTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        pwCheckMsgLabel.isHidden = true
        
        nickTextField.layer.cornerRadius = 10
        nickTextField.layer.borderWidth = 1
        nickTextField.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        nickOverlapBtn.layer.cornerRadius = 10
        
    }
    //알림창 설정
    private func enrollAlertEvent() {
        let nomalImgaAlertAction = UIAlertAction(title: "기본이미지", style: .default) {(action) in
            self.profileImageView.image = UIImage(systemName: "person.circle")
            self.profileImageView.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        
        let photoLibraryAlertAction = UIAlertAction(title: "사진 앨범", style: .default) {
            (action) in
            if self.PhotoAuth() {
                self.openAlbum()
            } else {
                self.AuthSettingOpen(AuthString: "앨범")
            }
            
        }
        
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        self.alertController.addAction(nomalImgaAlertAction)
        self.alertController.addAction(photoLibraryAlertAction)
        self.alertController.addAction(cancelAlertAction)
        guard let alertControllerPopoverPresentationController
                = alertController.popoverPresentationController
        else {return}
        prepareForPopoverPresentation(alertControllerPopoverPresentationController)
    }
    
    //MARK: - POSTOverlapId
    private func postOverlapId(_ parameters: OverlapIdRequest){
        
        AF.request(VALUNURL.overlapIdURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
//            .validate(statusCode: 200..<300)
            .validate()
            .responseDecodable(of: OverlapIdResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    VALUNLog.debug("PostOverlapId - Success")
                    
                    if response.data != nil {
                        if response.data?.available == true {
                            let overlapId_alert = UIAlertController(title: "성공", message:"사용가능한 아이디입니다", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            overlapId_alert.addAction(okAction)
                            present(overlapId_alert, animated: false, completion: nil)
                        }else {
                            let overlapId_alert = UIAlertController(title: "중복", message:"중복된 아이디입니다", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            overlapId_alert.addAction(okAction)
                            present(overlapId_alert, animated: false, completion: nil)
                        }
                    }
                    
                    
                case .failure(let error):
                    VALUNLog.error("PostOverlapId - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        switch (statusCode) {
                            case 400..<500:
                            let loginFail_alert = UIAlertController(title: "실패", message:"아이디를 확인해 주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            loginFail_alert.addAction(okAction)
                            present(loginFail_alert, animated: false, completion: nil)
                        default:
                            let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            loginFail_alert.addAction(okAction)
                            present(loginFail_alert, animated: false, completion: nil)
                        }
                    }
                }
            }
    }
    
    //MARK: - POSTOverlapNick
    private func postOverlapNick(_ parameters: OverlapNickRequest){
        
        AF.request(VALUNURL.overlapNickURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
//            .validate(statusCode: 200..<300)
            .validate()
            .responseDecodable(of: OverlapNickResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    VALUNLog.debug("PostOverlapNick - Success")
                    
                    if response.data != nil {
                        if response.data?.available == true {
                            let overlapNick_alert = UIAlertController(title: "성공", message:"사용가능한 닉네임입니다", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            overlapNick_alert.addAction(okAction)
                            present(overlapNick_alert, animated: false, completion: nil)
                        }else {
                            let overlapNick_alert = UIAlertController(title: "중복", message:"중복된 닉네임입니다", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            overlapNick_alert.addAction(okAction)
                            present(overlapNick_alert, animated: false, completion: nil)
                        }
                    }
                    
                    
                case .failure(let error):
                    VALUNLog.error("PostOverlapNick - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                        switch (statusCode) {
                            case 400..<500:
                            let loginFail_alert = UIAlertController(title: "실패", message:"닉네임을 확인해 주세요", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            loginFail_alert.addAction(okAction)
                            present(loginFail_alert, animated: false, completion: nil)
                        default:
                            let loginFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "확인", style: .default)
                            loginFail_alert.addAction(okAction)
                            present(loginFail_alert, animated: false, completion: nil)
                        }
                    }
                }
            }
    }
    
    //MARK: - Post Signup
    func postSignup(_ parameters: SignupRequest) {
        let headers: HTTPHeaders = ["Content - type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let id = parameters.id
            let pw = parameters.pw
            let nick = parameters.nick
            
//            let id = self.idTextField.text ?? ""
//            let pw = self.pwTextField.text ?? ""
//            let nick = self.nickTextField.text ?? ""
            
            let parameters: [String: Any] = [
                "id": id,
                "pw": pw,
                "nick": nick
            ]
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            self.imageData = self.profileImageView.image?.jpegData(compressionQuality: 0.5)
            
            if let image = self.imageData {
                multipartFormData.append(image, withName: "image", fileName: "test.jpeg", mimeType: "image/jpeg")
            }
            
        }, to: VALUNURL.signupURL, method: .post, headers: headers).responseDecodable(of: SignupResponse.self) {
            [self] response in
            switch response.result {
            case .success(let response):
                VALUNLog.debug("PostSignup-success")
                
                let signup_alert = UIAlertController(title: "성공", message: response.message, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
        
                }
                signup_alert.addAction(okAction)
                present(signup_alert, animated: false, completion: nil)
                
            case .failure(let error):
                VALUNLog.error("PostSignup - err")
                print(error.localizedDescription)
                if let statusCode = response.response?.statusCode {
                    print("에러코드 : \(statusCode)")
                    switch (statusCode) {
                        case 400..<500:
                        let signupFail_alert = UIAlertController(title: "실패", message:"입력을 확인해 주세요", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        signupFail_alert.addAction(okAction)
                        present(signupFail_alert, animated: false, completion: nil)
                    default:
                        let signupFail_alert = UIAlertController(title: "실패", message: "서버 통신 실패", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: .default)
                        signupFail_alert.addAction(okAction)
                        present(signupFail_alert, animated: false, completion: nil)
                    }
                }
            }
        }
    }
}
//MARK: Extension UIPopoverPresentation
extension SignupViewController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let popoverPresentationController =
            self.alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect
            = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
    }
}

//MARK: - Extension UIImagePicker
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        profileImageView.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        profileImageView.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    //앨범 띄우기
    func openAlbum() {
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: false, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil) //dismiss를 직접 해야함
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 포토 라이브러리 접근 권한
    func PhotoAuth() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        var isAuth = false
        
        switch authorizationStatus {
        case .authorized: return true // 사용자가 앱에 사진 라이브러리에 대한 액세스 권한을 명시 적으로 부여했습니다.
        case .denied: break // 사용자가 사진 라이브러리에 대한 앱 액세스를 명시 적으로 거부했습니다.
        case .limited: break // ?
        case .notDetermined: // 사진 라이브러리 액세스에는 명시적인 사용자 권한이 필요하지만 사용자가 아직 이러한 권한을 부여하거나 거부하지 않았습니다
            PHPhotoLibrary.requestAuthorization { (state) in
                if state == .authorized {
                    isAuth = true
                }
            }
            return isAuth
        case .restricted: break // 앱이 사진 라이브러리에 액세스 할 수있는 권한이 없으며 사용자는 이러한 권한을 부여 할 수 없습니다.
        default: break
        }
        
        return false;
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


//MARK: - Extension UITextField
extension SignupViewController: UITextFieldDelegate {
    
    private func setTextField() {
        
        self.idTextField.delegate = self
        self.pwTextField.delegate = self
        self.pwCheckTextField.delegate = self
        self.nickTextField.delegate = self
        
        
        //텍스트필드 입력값 변경 감지
        self.idTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.pwCheckTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        self.nickTextField.addTarget(self, action: #selector(self.TFdidChanged(_:)), for: .editingChanged)
        
        //버튼 활성/비활성 액션
        self.idTextField.addAction(UIAction(handler: { _ in
            if self.idTextField.text?.isEmpty == true {
                self.idMsgLabel.text = "영어 대소문자, 숫자 사용 5자이상 15자 이내"
                self.idMsgLabel.setGrayMsg()
                self.idOverlapBtn.setFalse()
            }else if self.idTextField.text!.count < 5 {
                self.idMsgLabel.text = "영어 대소문자, 숫자 사용 5자이상 15자 이내"
                self.idMsgLabel.setGrayMsg()
                self.idOverlapBtn.setFalse()
            }
            else {
                self.idOverlapBtn.setTrue()
            }
        }), for: .editingChanged)
        
        self.nickTextField.addAction(UIAction(handler: { _ in
            if self.nickTextField.text?.isEmpty == true {
                self.nickMsgLabel.text = "한글, 영어 대소문자, 숫자 사용 2자이상 15자 이내"
                self.nickMsgLabel.setGrayMsg()
                self.nickOverlapBtn.setFalse()
                
            }else if self.nickTextField.text!.count < 2 {
                self.nickMsgLabel.text = "영어 대소문자, 숫자 사용 5자이상 15자 이내"
                self.nickMsgLabel.setGrayMsg()
                self.nickOverlapBtn.setFalse()
                
            }else {
                self.nickOverlapBtn.setTrue()
            }
        }), for: .editingChanged)
        
    }
    
    //닉네임 형식 확인
    private func isValidNick(testStr: String) -> Bool {
        let nickRegEx = "[가-힣A-Za-z0-9]{2,15}"
        let nickTest = NSPredicate(format:"SELF MATCHES %@", nickRegEx)
        return nickTest.evaluate(with: testStr)
    }
    
    //아이디 형식 확인
    private func isValidID(testStr: String) -> Bool {
        let idRegEx = "[A-Za-z0-9]{5,15}"
        let idTest = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: testStr)
    }
    
    //비밀번호 형식 확인
    private func isValidPW(testStr: String) -> Bool {
        let pwRegEx = "[A-Za-z0-9!_@$%^&+=]{6,15}"
        let pwTest = NSPredicate(format:"SELF MATCHES %@", pwRegEx)
        return pwTest.evaluate(with: testStr)
    }
    
    private func isSameBothTextField(_ first: UITextField,_ second: UITextField) -> Bool {
        
        if(first.text == second.text) {
            
            return true
        } else {
            
            return false
        }
    }
    
    //텍스트 필드 입력값 변하면 유효성 검사
    @objc func TFdidChanged(_ sender: UITextField) {
        
        if self.pwTextField.text?.isEmpty == true{
            pwMsgLabel.text = "영어 대소문자, 숫자 기호(!_@$%^&+=])사용 6자 이상 15자 이내"
            pwMsgLabel.setGrayMsg()
        }else if self.pwCheckTextField.text?.isEmpty == true {
            pwCheckMsgLabel.isHidden = true
            pwCheckMsgLabel.setGrayMsg()
        }else if isSameBothTextField(pwTextField, pwCheckTextField) == true {
            pwCheckMsgLabel.isHidden = false
            pwCheckMsgLabel.text = "비밀번호가 일치합니다"
            pwCheckMsgLabel.setGreenMsg()
        }else {
            pwCheckMsgLabel.isHidden = false
            pwCheckMsgLabel.text = "비밀번호가 일치하지않습니다"
            pwCheckMsgLabel.setRedMsg()
        }
        
        
        //텍스트필드가 채워졌는지, 비밀번호가 일치하는 지 확인, 필수 약관을 동의 했는지
        if  !(self.pwTextField.text?.isEmpty ?? true) && !(self.pwCheckTextField.text?.isEmpty ?? true) &&  !(self.idTextField.text?.isEmpty ?? true) && !(self.nickTextField.text?.isEmpty ?? true) && isSameBothTextField(pwTextField, pwCheckTextField) {
            signupBtn.setTrue()
        }
        else {
            signupBtn.setFalse()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pwTextField {
            if isValidPW(testStr: pwTextField.text ?? "") == false {
                pwMsgLabel.text = "비밀번호 형식이 잘못되었습니다"
                pwMsgLabel.setRedMsg()
                let fail_alert = UIAlertController(title: "실패", message: "비밀번호 형식이 잘못되었습니다\n 영어 대소문자,숫자, !_@$%^&+= 사용 6~15자 이내", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                fail_alert.addAction(okAction)
                present(fail_alert, animated: false, completion: nil)
            }else {
                pwMsgLabel.text = "사용가능한 비밀번호입니다"
                pwMsgLabel.setGreenMsg()
            }
        }
    }
}



