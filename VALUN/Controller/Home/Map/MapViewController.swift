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
    
    @IBOutlet var naviView: UIView!
    
    @IBOutlet var categoryChoiceBtn: UIButton!
    
    @IBOutlet var filterView: UIView!
    
    @IBOutlet var filterViewConstraint: NSLayoutConstraint!
    @IBOutlet var filter_OneCollectionView: UICollectionView!
    
    
    @IBOutlet var filter_CancelBtn: UIButton!
    
    @IBOutlet var filter_ApplyBtn: UIButton!
    
    @IBOutlet var listBtn: UIButton!
    
    @IBOutlet var modalView: UIView!
    @IBOutlet var modalBtn: UIButton!
    
    @IBOutlet var modalViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var listBtnBottomToModalViewConstraint: NSLayoutConstraint!
    @IBOutlet var listBtnBottomToListViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var modalImage: UIImageView!
    @IBOutlet var modalCategory: UILabel!
    @IBOutlet var modalDistance: UILabel!
    @IBOutlet var modalDetailBtn: UIButton!
    @IBOutlet var modalSolveBtn: UIButton!
    
    @IBOutlet var listView: UIView!
    @IBOutlet var listViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var listTableView: UITableView!
    
    var tabletest1: [String] = ["test1", "test2", "test3"]
    var tabletest2: [String] = ["test1", "test2", "test3"]
    var tabletestImg: [String] = ["common1", "common2", "common3"]
    
    @IBOutlet var filterCollectionView: UICollectionView!
    
    var filterTuple: [(String, Bool)] = [("PET", false), ("금속", false), ("종이", false), ("플라스틱", false), ("일반쓰레기", false), ("스티로폼", false), ("유리", false), ("음식물 쓰레기", false), ("폐기물", false), ("목재", false), ("비닐", false), ("기타", false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        setUI()
        setTableView()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setMap()
        setUI()
    }
    
    //MARK: - Inner Func
    private func setUI() {
        
        //필터 초기화
        removeFilter()
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        // 뷰를 최상위로
        self.view.bringSubviewToFront(filterView)
        self.view.bringSubviewToFront(listBtn)
        self.view.bringSubviewToFront(modalBtn)
        self.view.bringSubviewToFront(modalView)
        self.view.bringSubviewToFront(listView)
        
        //둥글게
        
        categoryChoiceBtn.layer.cornerRadius = 10
        categoryChoiceBtn.layer.borderWidth = 1
        categoryChoiceBtn.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        filter_CancelBtn.layer.cornerRadius = 10
        filter_CancelBtn.layer.borderWidth = 1
        filter_CancelBtn.layer.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        filter_ApplyBtn.layer.cornerRadius = 10
        
        listBtn.layer.cornerRadius = 16
        modalView.layer.cornerRadius = 10
        modalView.clipsToBounds = true
        
        modalImage.layer.cornerRadius = 10
        
        listView.layer.cornerRadius = 10
        listView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        modalDetailBtn.layer.cornerRadius = 8
        modalDetailBtn.layer.borderWidth = 1
        modalDetailBtn.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor
        
        modalSolveBtn.layer.cornerRadius = 8
        modalSolveBtn.layer.borderWidth = 1
        modalSolveBtn.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor
        
    }
    
    //컬렉션뷰셀 클릭
    func cellClick(index: Int) {
        let newValue: (String, Bool) = (filterTuple[index].0, !filterTuple[index].1)
        filterTuple[index] = newValue
        filterCollectionView.reloadData()
        filter_OneCollectionView.reloadData()
    }
    
    //필터 초기화
    func removeFilter() {
        for index in 0..<filterTuple.endIndex {
            if filterTuple.map{$0.1}[index] == true {
                let changeValue: (String, Bool) = (filterTuple[index].0, !filterTuple[index].1)
                filterTuple[index] = changeValue
            }
        }
        filterCollectionView.reloadData()
        filter_OneCollectionView.reloadData()
    }
    
    //MARK: - IBAction
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func categoryChoiceBtnPressed(_ sender: UIButton) {

        self.filterViewConstraint.constant = 0
        
    }
    @IBAction func categoryDeleteBtnPressed(_ sender: UIButton) {
        categoryChoiceBtn.isHidden = false
        removeFilter()
    }
    
    @IBAction func filter_CancelBtnPressed(_ sender: UIButton) {
        
        self.filterViewConstraint.constant = -281
        removeFilter()

    }
    @IBAction func filter_ApplyBtnPressed(_ sender: UIButton) {
        
        self.filterViewConstraint.constant = -281
        
    }
    
    @IBAction func listBtnPressed(_ sender: UIButton) {
        if listBtn.titleLabel?.text == "  목록보기" {
            self.listBtnBottomToListViewConstraint.isActive = true // 리스트버튼과 리스트뷰의 제약온
            
            //커스텀 모달뷰 방법
            // Bottom 제약조건 높이 조절
            self.listViewBottomConstraint.constant = 0 // 리스트뷰와 슈퍼뷰
            self.listBtnBottomToListViewConstraint.constant = 16 //리스트버튼과 리스트뷰
            self.listBtnBottomToModalViewConstraint.isActive = false //리스트버튼과 모달뷰의 제약 오프
            
            // 애니메이션 실행
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            listBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            listBtn.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            listBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            listBtn.setTitle("  목록닫기", for: .normal)
            listBtn.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)
        }else {
            // 제약조건
            self.listViewBottomConstraint.constant = -self.listView.frame.height //리스트뷰와 슈퍼뷰
            self.listBtnBottomToListViewConstraint.constant = 64 //리스트버튼과 리스트뷰
            
            self.modalViewBottomConstraint.constant = -self.modalView.frame.height//모달뷰와 슈퍼뷰(모달을 열고 목록을 열고 닫고 했을때)
            
            
            // 애니메이션
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            listBtn.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            listBtn.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            listBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            listBtn.setTitle("  목록보기", for: .normal)
            listBtn.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)
        }
        
    }
    
    @IBAction func modalTest(_ sender: UIButton) {
        self.listBtnBottomToModalViewConstraint.isActive = true //리스트버튼과 모달뷰의 제약 온
        
        //커스텀 모달뷰 방법
        // Bottom 제약조건 높이 조절
        self.modalViewBottomConstraint.constant = 56 //모달뷰와 슈퍼뷰
        self.listBtnBottomToModalViewConstraint.constant = 16 //리스트버튼과 모달뷰
        self.listBtnBottomToListViewConstraint.isActive = false //리스트버튼과 리스트뷰의 제약 오프
        
        self.listViewBottomConstraint.constant = -self.listView.frame.height //리스트뷰와 슈퍼뷰
        listBtn.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listBtn.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        listBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        listBtn.setTitle("  목록보기", for: .normal)
        listBtn.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 14)
        
        // 애니메이션 실행
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func exitBtnPresed(_ sender: UIButton) {
        // 제약조건
        self.modalViewBottomConstraint.constant = -self.modalView.frame.height
        self.listBtnBottomToModalViewConstraint.constant = 64
        
        // 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @IBAction func modalDetailBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueDetail", bundle: nil)
        let issueDetailVC = storyBoard.instantiateViewController(identifier: "IssueDetailViewController")
        self.navigationController?.pushViewController(issueDetailVC, animated: true)
        
        // 현재 위치 트래킹
        mapView!.currentLocationTrackingMode = .off
        mapView!.showCurrentLocationMarker = false
    }
    @IBAction func modalSolveBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueResolution", bundle: nil)
        let issueResolutionVC = storyBoard.instantiateViewController(identifier: "IssueResolutionViewController")
        self.navigationController?.pushViewController(issueResolutionVC, animated: true)
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

//MARK: - CollectionViewExtension
extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //필터
    // CollectionView 셋팅
    func setCollectionView() {
        
        filterCollectionView.reloadData()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
        
        filter_OneCollectionView.delegate = self
        filter_OneCollectionView.dataSource = self
        filter_OneCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
    }

    
    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == filterCollectionView {
            count = filterTuple.filter{$0.1 == true}.count
            if count == 0 {
                categoryChoiceBtn.isHidden = false

            }else {
                categoryChoiceBtn.isHidden = true

            }

        }else if collectionView == filter_OneCollectionView {
            count = filterTuple.count

        }
        
        return count
    }
    
    // CollectionView Cell의 Object
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        if collectionView == filterCollectionView {
            cell.filterTitle.text = filterTuple.filter{$0.1 == true}.map{$0.0}[indexPath.row]
            cell.filterTitle.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.filterView.backgroundColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
            
        }else if collectionView == filter_OneCollectionView {
            
            cell.filterTitle.text = filterTuple.map{$0.0}[indexPath.row]
            cell.filterTitle.textColor =  UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            cell.filterView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
            cell.cellBool = filterTuple.map{$0.1}[indexPath.row]

        }
        

        
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        cellClick(index: indexPath.row)
        
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        
        if collectionView == filterCollectionView {
            let width: CGFloat = collectionView.frame.width / 4 - 1.0
            size = CGSize(width: width, height: 29)
        } else if collectionView == filter_OneCollectionView {
            
            let width: CGFloat = collectionView.frame.width / 5 - 1.0
            size = CGSize(width: width, height: 29)
        }
        
       
        
        return size
    }
    
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
}

//MARK: - TableViewExtension
extension MapViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    // TableView 셋팅
    private func setTableView() {
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.listTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil),  forCellReuseIdentifier: "ListTableViewCell")
        
        listTableView.separatorStyle = UITableViewCell.SeparatorStyle.none //테이블뷰 셀 선 없애기
        
    }
    
    
    //Cell 갯수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabletest1.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        cell.listCategory.text = tabletest1[indexPath.row]
        cell.listDestance.text = tabletest2[indexPath.row]
        cell.listImage.image = UIImage(named: tabletestImg[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
