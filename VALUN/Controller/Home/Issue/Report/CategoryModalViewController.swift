//
//  CategoryModalViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/10.
//

import UIKit

protocol DimissAction: AnyObject {
    func GetTitle(categoryTitle: String)
}

class CategoryModalViewController: UIViewController {

    @IBOutlet var modalView: UIView!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var choiceBtn: UIButton!
    @IBOutlet var categoryCollectionView: UICollectionView!
    
    var categoryList: [String] = ["pet", "metal", "paper", "plastic", "trash", "styrofoam", "glass", "garbage", "waste", "lumber", "vinyl", "etc"]
    
    var categoryDictionary: Dictionary<String, String> = ["pet":"PET", "metal":"금속", "paper":"종이", "plastic":"플라스틱", "trash":"일반쓰레기", "styrofoam":"스티로폼", "glass":"유리", "garbage":"음식물 쓰레기", "waste":"폐기물", "lumber":"목재", "vinyl":"비닐", "etc":"기타"]
    
    var categoryString = ""
            
    weak var delegate: DimissAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
    }
    
    //MARK: - IBAction
    @IBAction func choiceBtnPressed(_ sender: UIButton) {
        delegate?.GetTitle(categoryTitle: categoryString)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - INNER Func
    //백그라운드 터치시 뷰컨 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first , touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setUI() {
        
        modalView.layer.cornerRadius = 10
        choiceBtn.layer.cornerRadius = 10
    }
}

//MARK: - CollectionViewExtension
extension CategoryModalViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //필터
    // CollectionView 셋팅
    func setCollectionView() {
        
        categoryCollectionView.reloadData()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "ReportIssueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReportIssueCollectionViewCell")
        
        categoryCollectionView.showsVerticalScrollIndicator = false
    }

    
    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryList.count
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportIssueCollectionViewCell", for: indexPath) as! ReportIssueCollectionViewCell
        
        cell.categoryImage.image = UIImage(named: categoryList[indexPath.row])
                
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 클릭된 셀을 가져옴
        let cell = collectionView.cellForItem(at: indexPath) as! ReportIssueCollectionViewCell
        
        cell.categoryIndex = indexPath.row
        if cell.categoryBool == true {

            cell.categoryBool = false
            categoryString = ""
        }
        else {
            print(categoryList[indexPath.row])
            categoryString = categoryDictionary[categoryList[indexPath.row]] ?? ""
            cell.categoryBool = true
        }
        
        
        
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let width: CGFloat = collectionView.frame.width / 2 - 1.0
        
        return CGSize(width: 134, height: 124)
    }
    
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 22.0
    }
    
}


