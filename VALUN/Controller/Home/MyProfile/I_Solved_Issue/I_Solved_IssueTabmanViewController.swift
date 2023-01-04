//
//  I_Solved_IssueTabManViewController.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/04.
//

import UIKit
import Tabman
import Pageboy

class I_Solved_IssueTabmanViewController: TabmanViewController {

    private var viewControllers: [UIViewController] = []
    let allVC = UIStoryboard.init(name: "I_Solved_Issue", bundle: nil).instantiateViewController(withIdentifier: "Solved_AllIssueViewController") as! Solved_AllIssueViewController
    
    let solvingVC = UIStoryboard.init(name: "I_Solved_Issue", bundle: nil).instantiateViewController(withIdentifier: "Solved_SolvingViewController") as! Solved_SolvingViewController
    
    let completedVC = UIStoryboard.init(name: "I_Solved_Issue", bundle: nil).instantiateViewController(withIdentifier: "Solved_CompletedViewController") as! Solved_CompletedViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabView()
    }
    //MARK: - INNER FUNC
    func setTabView() {
        viewControllers.append(allVC)
        viewControllers.append(solvingVC)
        viewControllers.append(completedVC)
        
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        //탭바 레이아웃 설정
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .leading
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 22.0, bottom: 0.0, right: 20.0)
//        bar.layout.contentMode = .fit
        
        
        //배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor.white
        
        //버튼 글시 커스텀
        bar.buttons.customize{(button) in
            button.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
            button.selectedTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            button.font = UIFont(name: "SUIT-Bold", size: 15)!
            
        }
        
        //indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1)
        
        addBar(bar, dataSource: self, at:.top)
    }
    
}

//MARK: - Extension Pageboy, TMBar
extension I_Solved_IssueTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "전체")
        case 1:
            return TMBarItem(title: "해결중")
        case 2:
            return TMBarItem(title: "해결완료")

        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
