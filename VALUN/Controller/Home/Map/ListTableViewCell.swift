//
//  ListTableViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2022/12/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var listImage: UIImageView! {
        didSet {
            listImage.layer.cornerRadius = 10
        }
    }
    @IBOutlet var listCategory: UILabel!
    @IBOutlet var listDeatance: UILabel!
    @IBOutlet var listSolveBtn: UIButton! {
        didSet{
            listSolveBtn.layer.cornerRadius = 8
            listSolveBtn.layer.borderWidth = 1
            listSolveBtn.layer.borderColor = UIColor(red: 0.416, green: 0.769, blue: 0.478, alpha: 1).cgColor

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
