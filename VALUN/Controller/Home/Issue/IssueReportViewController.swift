//
//  IssueReportViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/25.
//

import UIKit
import AVFoundation

class IssueReportViewController: UIViewController {
    
    @IBOutlet var issueReportImage: UIImageView!
    @IBOutlet var cameraImgView: UIImageView!
    
    @IBOutlet var choiceBtn: UIButton!
    @IBOutlet var categoryBtn: UIButton!
    
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var placeholder: UILabel!
    
    
    @IBOutlet var issueReportBtn: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    let textViewPlaceHolder = "이슈에 대한 내용을 작성해 주세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setImagePicker()
        setTextView()
    }
    
    //MARK: - OBJC
    //이미지 탭 제스쳐
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        present(imagePickerController, animated: true)
    }
    
    //MARK: - IBAction
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func choiceBtnPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func issueReportBtnPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - INNER Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        issueReportImage.layer.cornerRadius = 10
        issueReportImage.layer.borderWidth = 1
        issueReportImage.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        choiceBtn.layer.cornerRadius = 10
        
        categoryBtn.layer.cornerRadius = 10
        categoryBtn.isEnabled = false
        categoryBtn.isHidden = true // 선택전
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor(red: 0.886, green: 0.886, blue: 0.886, alpha: 1).cgColor
        
        issueReportBtn.layer.cornerRadius = 10
        
        
        
        
    }
    
}

//MARK: - Extension UIImagePicker
extension IssueReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        //이미지뷰 클릭동작
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //이미지뷰가 상호작용할 수 있게 설정
        issueReportImage.isUserInteractionEnabled = true
        //이미지뷰에 제스처인식기 연결
        issueReportImage.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    //이미지가 지정되었을 때 호출되는 델리게이트 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imagePickerController.dismiss(animated: true)
        
        // 선택된 이미지(소스)가 없을수도 있으니 옵셔널 바인딩해주고, 이미지가 선택된게 없다면 오류를 발생시킵니다.
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        cameraImgView.isHidden = true
        issueReportImage.image = userPickedImage
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
