//
//  ReportIssueCollectionViewCell.swift
//  VALUN
//
//  Created by 김동겸 on 2023/01/10.
//

import UIKit

class ReportIssueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var categoryImage: UIImageView!
    var categoryList: [String] = ["pet", "metal", "paper", "plastic", "trash", "styrofoam", "glass", "garbage", "waste", "lumber", "vinyl", "etc"]
    
    var categoryIndex = 0
    var categoryBool = false {
        didSet {
            
            if categoryBool == false {
                categoryImage.image = UIImage(named: categoryList[categoryIndex])
                
            }else {
                categoryImage.image = UIImage(named: "\(categoryList[categoryIndex])_set")
                
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                categoryImage.image = UIImage(named: categoryList[categoryIndex])
                categoryBool = false
            }
        }
    }
}
