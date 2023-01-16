//
//  ViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/13.
//

import UIKit
import Alamofire
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet var subView: UIView!
    var mapView: MTMapView?
    
    @IBOutlet var naviView: UIView!
    
    @IBOutlet var categoryChoiceBtn: UIButton!
    
    @IBOutlet var filterView: UIView!
    
    @IBOutlet var filterViewConstraint: NSLayoutConstraint!
    @IBOutlet var filterListCollectionView: UICollectionView!
    
    
    @IBOutlet var filter_CancelBtn: UIButton!
    
    @IBOutlet var filter_ApplyBtn: UIButton!
    
    @IBOutlet var listBtn: UIButton!
    
    @IBOutlet var modalView: UIView!
    
    @IBOutlet var modalViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var listBtnBottomToModalViewConstraint: NSLayoutConstraint!
    @IBOutlet var listBtnBottomToListViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var modalImage: UIImageView!
    @IBOutlet var modalCategory: UILabel!
    @IBOutlet var modalDistance: UILabel!
    @IBOutlet var modalDetailBtn: UIButton!
    @IBOutlet var modalSolveBtn: UIButton!
    var modalObject: [Issue] = []
    
    @IBOutlet var listView: UIView!
    @IBOutlet var listViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var listTableView: UITableView!
    var listObject: [Issue] = []
    
    var tabletest1: [String] = ["test1", "test2", "test3"]
    var tabletest2: [String] = ["test1", "test2", "test3"]
    var tabletestImg: [String] = ["common1", "common2", "common3"]
    
    @IBOutlet var filterCollectionView: UICollectionView!
    
    var filterTuple: [(String, Bool)] = [("PET", false), ("금속", false), ("종이", false), ("플라스틱", false), ("일반쓰레기", false), ("스티로폼", false), ("유리", false), ("음식물 쓰레기", false), ("폐기물", false), ("목재", false), ("비닐", false), ("기타", false)]
    
    //키 한글 -> 밸류 영어
    var filterDictionary: Dictionary<String, String> = ["PET":"pet,", "금속":"metal,", "종이":"paper,", "플라스틱":"plastic,", "일반쓰레기":"trash,", "스티로폼":"styrofoam,", "유리":"glass,", "음식물 쓰레기":"garbage,", "폐기물":"waste,", "목재":"lumber,", "비닐":"vinyl,", "기타":"etc,"]
    
    //키 영어 -> 밸류 한글
    var categoryDictionary: Dictionary<String, String> = ["pet":"PET", "metal":"금속", "paper":"종이", "plastic":"플라스틱", "trash":"일반쓰레기", "styrofoam":"스티로폼", "glass":"유리", "garbage":"음식물 쓰레기", "waste":"폐기물", "lumber":"목재", "vinyl":"비닐", "etc":"기타"]
    
    var filterStringList: [String] = []
    var filterString = ""
    
    //현재 위치
    var lat_now = 0.0
    var lng_now = 0.0
    
    //최근 이슈
    var nearIssueList: [Issue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //필터 초기화
        removeFilter()
        
        setMap()
        setUI()
        setTableView()
        setCollectionView()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.getNearIssue()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("뷰윌어피어")
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        setMap()
        setUI()
        setPin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("윌디스어피어")
//        removeFilter()
//        for item in mapView!.poiItems {
//            mapView!.remove(item as! MTMapPOIItem)
//        }
//
//        //모달
//        // 제약조건
//        self.modalViewBottomConstraint.constant = -self.modalView.frame.height
//        self.listBtnBottomToModalViewConstraint.constant = 64
//
//        // 애니메이션
//        UIView.animate(withDuration: 0.3, delay: 0, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("윌디드어피어")

    }
    
    //MARK: - IBAction
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func categoryChoiceBtnPressed(_ sender: UIButton) {
        self.filterViewConstraint.constant = 0
        
    }
    @IBAction func categoryDeleteBtnPressed(_ sender: UIButton) {
        categoryChoiceBtn.isHidden = false
        removeFilter()
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        getNearIssue()
    }
    
    @IBAction func filter_CancelBtnPressed(_ sender: UIButton) {
        
        self.filterViewConstraint.constant = -281
        removeFilter()
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        getNearIssue()
    }
    @IBAction func filter_ApplyBtnPressed(_ sender: UIButton) {
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        
        self.filterViewConstraint.constant = -281
        filterToString()
        getNearIssue()
        
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
        let issueDetailVC = storyBoard.instantiateViewController(identifier: "IssueDetailViewController") as! IssueDetailViewController
        self.navigationController?.pushViewController(issueDetailVC, animated: true)
        
        // 현재 위치 트래킹
        mapView!.currentLocationTrackingMode = .off
        mapView!.showCurrentLocationMarker = false
        
        issueDetailVC.paramIssueObject = modalObject
        let distance = modalDistance.text
        issueDetailVC.paramIssueDistance = distance ?? ""
    }
    @IBAction func modalSolveBtnPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "IssueResolution", bundle: nil)
        let issueResolutionVC = storyBoard.instantiateViewController(identifier: "IssueResolutionViewController") as! IssueResolutionViewController
        self.navigationController?.pushViewController(issueResolutionVC, animated: true)
        
        issueResolutionVC.paramIsssueObject = modalObject
    }
    
    //MARK: - Inner Func
    private func setUI() {
        
        //네비바 숨김
        self.navigationController?.navigationBar.isHidden = true
        
        // 뷰를 최상위로
        self.view.bringSubviewToFront(filterView)
        self.view.bringSubviewToFront(listBtn)
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
        filterListCollectionView.reloadData()
        
    }
    
    //필터 초기화
    func removeFilter() {
        for index in 0..<filterTuple.endIndex {
            if filterTuple.map{$0.1}[index] == true {
                let changeValue: (String, Bool) = (filterTuple[index].0, !filterTuple[index].1)
                filterTuple[index] = changeValue
            }
        }
        
        filterString = ""
        filterStringList.removeAll()
        nearIssueList.removeAll()
        listTableView.reloadData()
        filterCollectionView.reloadData()
        filterListCollectionView.reloadData()
    }
    
    func filterToString() {
        var baseValue = ""
        var changeValue = ""
        filterString = ""
        
        for index in 0..<filterStringList.endIndex {
            baseValue = filterStringList[index]
            changeValue = filterDictionary[baseValue] ?? ""
            filterString = "\(filterString)\(changeValue)"
        }
        
    }
    
    //거리계산
    private func  distance(lat: Double, lng: Double) -> Int{
        let from = CLLocation(latitude: lat_now, longitude: lng_now)
        let to = CLLocation(latitude: lat, longitude: lng)
        
        let distance = Int(from.distance(from: to))
        return distance
        
    }
    
    //MARK: - Get RecentIssue
    let header: HTTPHeaders = ["authorization": UserDefaults.standard.string(forKey: "token")!]
    
    private func getNearIssue() {
        AF.request("\(VALUNURL.nearIssueURL)?lat=\(lat_now)&lng=\(lng_now)&categories=\(filterString)", method: .get, headers: header)
            .validate()
            .responseDecodable(of: NearIssueResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(VALUNLog.debug("getNearIssue-success"))
                    
                    if response.data != nil {
                        nearIssueList.removeAll()
                        nearIssueList = response.data?.issues ?? []
                        setPin()
                        listTableView.reloadData()
                    }
                    
                case .failure(let error):
                    VALUNLog.error("getRecentIssue_Map - err")
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode {
                        print("에러코드 : \(statusCode)")
                    }
                    
                }
            }
    }
    
}

//MARK: - MapExtension
extension MapViewController: MTMapViewDelegate {
    
    private func setMap() {
        // 지도 불러오기
        
       // DispatchQueue.main.async { [weak self] in
            // 2022 wwdc what's new swift 참고
       //     guard let self else { return }
            
            self.mapView = MTMapView(frame: self.subView.frame)
            
            
            if let mapView = self.mapView {
                // 델리게이트 연결
                mapView.delegate = self
                // 지도의 타입 설정 - hybrid: 하이브리드, satellite: 위성지도, standard: 기본지도
                mapView.baseMapType = .standard
                mapView.setZoomLevel(0, animated: true)
                
                // 현재 위치 트래킹
                DispatchQueue.main.async {
                    mapView.currentLocationTrackingMode = .onWithoutHeading
                    mapView.showCurrentLocationMarker = true
                    
                }
                
                self.view.addSubview(mapView)
            }
        //}
        
        
    }
    
    //핀찍기
    private func setPin() {
        var cnt = 0
        for index in 0..<nearIssueList.endIndex {
            let item = nearIssueList[index]
            let poiltem = MTMapPOIItem()
            poiltem.markerType = .customImage
            poiltem.customImageName = "\(item.category)_pin"
            poiltem.markerSelectedType = .customImage
            poiltem.customSelectedImageName = "\(item.category)_pin"
            poiltem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.lat, longitude: item.lng))
            poiltem.tag = cnt
            mapView!.addPOIItems([poiltem])
            cnt += 1
        }
    }
    
    //핀 클릭
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        
        //모달창
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
        
        //모달창 정보
        let url = URL(string: nearIssueList[poiItem.tag].imageUrl)
        modalImage.kf.setImage(with: url)
        
        modalCategory.text = categoryDictionary[nearIssueList[poiItem.tag].category]
        modalDistance.text = "\(distance(lat: nearIssueList[poiItem.tag].lat, lng: nearIssueList[poiItem.tag].lng)) m"
        
        modalObject.removeAll()
        modalObject.append(nearIssueList[poiItem.tag])
        
        return false
    }
    
    //현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            //               print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
            lat_now = latitude
            lng_now = longitude
            
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
        filterCollectionView.showsHorizontalScrollIndicator = false
        
        filterListCollectionView.delegate = self
        filterListCollectionView.dataSource = self
        filterListCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FilterCollectionViewCell")
    }
    
    
    // CollectionView item 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == filterCollectionView {
            count = filterTuple.filter{$0.1 == true}.count
            if count == 0 {
                categoryChoiceBtn.isHidden = false
                removeFilter()
            }else {
                categoryChoiceBtn.isHidden = true
                
            }
            
        }else if collectionView == filterListCollectionView {
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
            
            filterStringList.removeAll()
            filterStringList = filterTuple.filter{$0.1 == true}.map{$0.0}
            
        }else if collectionView == filterListCollectionView {
            
            cell.filterTitle.text = filterTuple.map{$0.0}[indexPath.row]
            cell.filterTitle.textColor =  UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            cell.filterView.backgroundColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
            cell.cellBool = filterTuple.map{$0.1}[indexPath.row]
            
        }
        
        
        
        return cell
    }
    
    // CollectionView Cell 터치
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == filterListCollectionView {
            cellClick(index: indexPath.row)

        }
        
    }
    
    // CollectionView Cell의 Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        
        if collectionView == filterCollectionView {
            let width: CGFloat = collectionView.frame.width / 4 - 1.0
            size = CGSize(width: width, height: 29)
        } else if collectionView == filterListCollectionView {
            
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
        return nearIssueList.count
    }
    
    //각Row에서 해당하는 Cell을 Return하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        cell.delegate = self
        
        let url = URL(string: nearIssueList[indexPath.row].imageUrl)
        cell.listImage.kf.setImage(with: url)
        
        cell.listCategory.text = categoryDictionary[nearIssueList[indexPath.row].category]
        cell.listDestance.text = "\(distance(lat: nearIssueList[indexPath.row].lat, lng: nearIssueList[indexPath.row].lng)) m"
        
        cell.selectionStyle = .none
        
        listObject.append(nearIssueList[indexPath.row])
        
        return cell
    }
    
    //클릭한 셀의 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "IssueDetail", bundle: nil)
        let issueDetailVC = storyBoard.instantiateViewController(identifier: "IssueDetailViewController") as! IssueDetailViewController
        self.navigationController?.pushViewController(issueDetailVC, animated: true)
        
        issueDetailVC.paramIssueObject.append(nearIssueList[indexPath.row])
        issueDetailVC.paramIssueDistance = "\(distance(lat: nearIssueList[indexPath.row].lat, lng: nearIssueList[indexPath.row].lng)) m"
        
        // 현재 위치 트래킹
        mapView!.currentLocationTrackingMode = .off
        mapView!.showCurrentLocationMarker = false
    }
}

extension MapViewController: NaviAction {
    func moveSolveVC() {
        let storyBoard = UIStoryboard(name: "IssueResolution", bundle: nil)
        let issueResolutionVC = storyBoard.instantiateViewController(identifier: "IssueResolutionViewController") as! IssueResolutionViewController
        self.navigationController?.pushViewController(issueResolutionVC, animated: true)
        
        issueResolutionVC.paramIsssueObject = listObject
    }
    
}
