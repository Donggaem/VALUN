//
//  ListTableViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/27.
//

import UIKit

protocol NaviAction: AnyObject {
    
    func moveSolveVC()
}

class ListTableViewCell: UITableViewCell {

    weak var delegate: NaviAction?
    
    @IBOutlet var listImage: UIImageView! {
        didSet {
            listImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet var listCategory: UILabel!
    @IBOutlet var listDestance: UILabel!
    @IBOutlet var listSolveBtn: UIButton! {
        didSet{
            listSolveBtn.layer.cornerRadius = 8
            listSolveBtn.layer.borderWidth = 1
            listSolveBtn.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor

        }
    }
    
    @IBAction func listSolveBtnPressed(_ sender: UIButton) {
        print("해결하기 버튼 클릭")
        self.delegate?.moveSolveVC()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
